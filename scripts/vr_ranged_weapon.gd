extends XRToolsPickable
class_name VRRangedWeapon

enum WeaponState {
	LOADED,
	UNLOADED,
	FIRED
}

@export var magazine_snap_zone: XRToolsSnapZone
@export var animation_player: AnimationPlayer
@export var casing_spawn_point: Node3D
@export var slide_pickup: XRToolsPickable
@export var slide_origin: Node3D
@export var max_pullback_slide: float = 0.021
@export var bone_name: String
@export var audio_player: AudioStreamPlayer3D
@export var polyphonic_stream: AudioStreamPolyphonic
@export var ranged_weapon: RangedWeapon
@export var bullet_trail_prefab: PackedScene
@export var casing_scene: PackedScene
@export var trail_spawn_point: Node3D
@export var bullet_spread_angle: float = 0.0
@export var loaded_bullet: Node3D
@export_flags_3d_physics var collision_layers
var audio_streams: Array[int]
var polyphonic_player: AudioStreamPlaybackPolyphonic
var slide_orig_pos: Vector3
var magazine: VRMagazine
@export var skeleton: Skeleton3D
var bone_id
var slide_layer
var slide_start_pos: Vector3
var weapon_state = WeaponState.LOADED
var prev_slide_pullback: float = 0.0
@export var round_chambered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	bone_id = skeleton.find_bone(bone_name)
	slide_pickup.enabled = false
	slide_orig_pos = slide_origin.transform.origin
	slide_layer = slide_pickup.collision_layer
	slide_pickup.collision_layer = 0
	polyphonic_stream = AudioStreamPolyphonic.new()
	polyphonic_stream.polyphony = 32
	audio_player.stream = polyphonic_stream
	audio_player.play()
	polyphonic_player = audio_player.get_stream_playback()
	audio_streams = []
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#super()
	if is_picked_up() and get_picked_up_by_controller() and get_picked_up_by_controller().is_button_pressed("by_button"):
		if magazine and !animation_player.is_playing():
			animation_player.play("EjectMagazine")
			play_sound(ranged_weapon.drop_magazine_sound)
	
	if round_chambered:
		$Label3D.modulate = Color.GREEN
	else:
		$Label3D.modulate = Color.WHITE
	
	if slide_pickup.is_picked_up():
		var slide_pos = slide_pickup.global_transform.origin
		var slide_pickup_local = slide_pos * slide_origin.global_transform
		#print(slide_pickup_local)
		
		var pullback = max(slide_start_pos.z, clampf(slide_pickup_local.z, slide_start_pos.z, (max_pullback_slide) + slide_start_pos.z))
		print(pullback)
		if pullback < max_pullback_slide + slide_start_pos.z:
			var bone_pose = skeleton.get_bone_rest(bone_id).origin
			bone_pose.y = bone_pose.y - pullback + slide_start_pos.z
			#print(bone_pose)
			skeleton.set_bone_pose_position(bone_id, bone_pose)
			if pullback == slide_start_pos.z and pullback != prev_slide_pullback:
				play_sound(ranged_weapon.slide_release_sound)
		else:
			if prev_slide_pullback != pullback:
				var round_count = 0
				if round_chambered:
					round_chambered = false
					loaded_bullet.hide()
					eject_casing()
				if magazine:
					#magazine.use_ammo()
					round_count += magazine.ammo_count
				$Label3D.text = str(round_count)
				play_sound(ranged_weapon.slide_pull_sound)
			if slide_pickup_local.z > (max_pullback_slide * 5) + slide_start_pos.z:
				slide_pickup.drop()
			#slide_pickup.drop()
		prev_slide_pullback = pullback
	elif !animation_player.is_playing() and magazine and magazine.has_bullets():
		if skeleton.get_bone_pose_position(bone_id) != skeleton.get_bone_rest(bone_id).origin:
			var bone_pose = skeleton.get_bone_pose_position(bone_id)
			bone_pose.y = lerp(bone_pose.y, skeleton.get_bone_rest(bone_id).origin.y, 0.5)
			#print(bone_pose)
			skeleton.set_bone_pose_position(bone_id, bone_pose)
			if skeleton.get_bone_pose_position(bone_id) == skeleton.get_bone_rest(bone_id).origin:
				play_sound(ranged_weapon.slide_release_sound)
				var round_count = 0
				if !round_chambered && magazine && magazine.has_bullets():
					round_chambered = true
					loaded_bullet.show()
				if magazine:
					magazine.use_ammo()
					round_count += magazine.ammo_count
				$Label3D.text = str(round_count)

func _on_magazine_loaded():
	pass

func _on_magazine_ejected():
	magazine_snap_zone.drop_object()
	magazine.enable_collision()
	if magazine.ammo_count > 0:
		magazine.enabled = true
	magazine = null
	var round_count: int = 0
	if round_chambered:
		round_count = 1
	$Label3D.text = str(round_count)

func _on_MagazineSnapZone_has_picked_up(object):
	print(object)
	magazine = object
	magazine.disable_collision()
	magazine.enabled = false
	if round_chambered:
		$Label3D.text = str(magazine.ammo_count + 1)
	else:
		$Label3D.text = str(magazine.ammo_count)
	animation_player.play("LoadMagazine")
	play_sound(ranged_weapon.load_magazine_sound)

func _on_picked_up(pickable):
	slide_pickup.enabled = true
	slide_pickup.collision_layer = slide_layer
	var round_count: int = 0
	if magazine:
		round_count += magazine.ammo_count
	if round_chambered:
		round_count += 1
	$Label3D.text = str(round_count)

func _on_dropped(pickable):
	if slide_pickup.is_picked_up():
		slide_pickup.drop()
	slide_pickup.enabled = false
	slide_pickup.collision_layer = 0

func _on_Slide_picked_up(pickable):
	slide_start_pos = slide_pickup.transform.origin
	prev_slide_pullback = slide_start_pos.z

func _on_Slide_dropped(pickable):
	slide_pickup.transform = slide_origin.transform
	slide_pickup.position = Vector3.ZERO
	#skeleton.set_bone_pose(bone_id, skeleton.get_bone_rest(bone_id))

func eject_casing():
	if casing_scene:
		var bullet_casing: RigidBody3D = casing_scene.instantiate()
		bullet_casing.set_as_top_level(true)
		bullet_casing.global_transform = casing_spawn_point.global_transform
		add_child(bullet_casing)
		bullet_casing.linear_velocity = bullet_casing.global_transform.basis.y * 2 + bullet_casing.global_transform.basis.x * 0.5

func fire(pickable):
	if round_chambered:
		if slide_pickup.is_picked_up():
			slide_pickup.drop()
		if !animation_player.is_playing():
			round_chambered = false
			loaded_bullet.hide()
			play_sound(ranged_weapon.attack_sounds[randi_range(0, ranged_weapon.attack_sounds.size() - 1)])
			animation_player.play("Fire")
			eject_casing()
			#magazine.use_ammo()
			var bullets_count = 0
			if magazine:
				if magazine.ammo_count > 0:
					magazine.use_ammo()
					bullets_count = magazine.ammo_count
					round_chambered = true
			if round_chambered:
				bullets_count += 1
			$Label3D.text = str(bullets_count)
			if !round_chambered:
				animation_player.play("EmptyFire")
			get_picked_up_by_controller().find_child("XRToolsRumbler").rumble()
			hitscan_raycast()
	else:
		if !animation_player.is_playing():
			animation_player.play("EmptyFire")

func play_sound(stream: AudioStream):
	if !stream:
		return
	for i in audio_streams:
		if !polyphonic_player.is_stream_playing(i):
			polyphonic_player.stop_stream(i)
	#var stream = ranged_weapon.attack_sounds[randi_range(0, ranged_weapon.attack_sounds.size() - 1)]
	var res = polyphonic_player.play_stream(stream)
	var rand_pitch = randf_range(0.9, 1.1)
	polyphonic_player.set_stream_pitch_scale(res, rand_pitch)
	audio_streams.append(res)

func hitscan_raycast() -> int:
	var space = get_world_3d().direct_space_state
	var random_spread_x = randf_range(-bullet_spread_angle, bullet_spread_angle)
	var random_spread_y = randf_range(-bullet_spread_angle, bullet_spread_angle)
	var query = PhysicsRayQueryParameters3D.create(trail_spawn_point.global_position,
			trail_spawn_point.global_position - trail_spawn_point.global_transform.basis.z * 1000)
	query.collision_mask = collision_layers
	query.to = Vector3(query.to.x + random_spread_x, query.to.y + random_spread_y, query.to.z)
	var collision = space.intersect_ray(query)
	if collision:
		print(collision["collider"])
		var bullet_trail_spawn: BulletTrail = bullet_trail_prefab.instantiate()
		get_tree().root.add_child(bullet_trail_spawn)
		bullet_trail_spawn.draw(trail_spawn_point.global_position, collision.position)
		if collision is RigidBody3D:
			collision["collider"].apply_impulse(query.to, collision.position)
		if collision["collider"].has_method("damage"):
			#intersection["collider"].player = self
			var ret = collision["collider"].damage(ranged_weapon.loaded_ammo_type.damage)
			#if (ret == 1 || ret == 2) && collision["collider"].attached_enemy.npc_template.blood_impact_effect_path != "":
				#var impact_effect: ImpactEffect = load(collision["collider"].attached_enemy.npc_template.blood_impact_effect_path).instantiate()
				#get_tree().root.add_child(impact_effect)
				#impact_effect.spawn(collision.position, collision.normal)
		bullet_trail_spawn.draw_impact(true, collision.position, collision.normal)
		#else:
			#bullet_trail_spawn.draw_impact(false, collision.position, collision.normal)
			#if generic_impact_effect != "":
				#var impact_effect: ImpactEffect = load(generic_impact_effect).instantiate()
				#get_tree().root.add_child(impact_effect)
				#impact_effect.spawn(collision.position, collision.normal)
			#if current_ranged_weapon.loaded_ammo_type.impact_effect != null:
				#var impact_effect: ImpactEffect = current_ranged_weapon.loaded_ammo_type.impact_effect.instantiate()
				#get_tree().root.add_child(impact_effect)
				#impact_effect.spawn(collision.position, collision.normal)
		return 0
	else:
		var bullet_trail_spawn: BulletTrail = bullet_trail_prefab.instantiate()
		get_tree().root.add_child(bullet_trail_spawn)
		bullet_trail_spawn.draw(trail_spawn_point.global_position, query.to)
		return 1
