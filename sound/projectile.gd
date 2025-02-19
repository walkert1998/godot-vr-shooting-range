class_name Projectile extends Node3D

@export var projectile_speed: float = 50.0
@export var projectile_direction: Vector3
@export var projectile_lifetime: float = 5.0
@export var damage: int = 10
@export var projectile_drop: bool = false
@export var penetrate_multiple_targets: bool = false
@export var generic_impact_effect: PackedScene
@export var dirt_impact_effect: PackedScene
@export var metal_impact_effect: PackedScene
@export var wood_impact_effect: PackedScene
var previous_position: Vector3
var total_distance: float = 0
var projectile_free_timer: Timer
var source

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_direction = -global_transform.basis.z
	previous_position = global_transform.origin
	projectile_free_timer = Timer.new()
	projectile_free_timer.connect("timeout", destroy_projectile)
	projectile_free_timer.set_wait_time(projectile_lifetime)
	projectile_free_timer.set_one_shot(true)
	add_child(projectile_free_timer)
	projectile_free_timer.start()

func destroy_projectile():
	queue_free()

func _physics_process(delta):
	var new_position = global_transform.origin + (projectile_direction * projectile_speed * delta)
	global_transform.origin = new_position
	#print("new_position: " + str(new_position))
	previous_position = new_position
	
	var distance = previous_position.distance_to(new_position)
	
	$RayCast3D.force_raycast_update()
	if $RayCast3D.is_colliding():
		new_position = $RayCast3D.get_collision_point()
		#if $RayCast3D.get_collider().has_method("damage"):
			#var hit = $RayCast3D.get_collider().damage(damage)
			#print_debug(str(hit))
		if generic_impact_effect:
			spawn_impact_effect($RayCast3D.get_collider(), $RayCast3D.get_collision_point(),  $RayCast3D.get_collision_normal(), generic_impact_effect)
		if $RayCast3D.get_collider().has_method("damage"):
			var hit = $RayCast3D.get_collider().damage(damage, source)
		elif dirt_impact_effect:
			spawn_impact_effect($RayCast3D.get_collider(), $RayCast3D.get_collision_point(),  $RayCast3D.get_collision_normal(), dirt_impact_effect)
			#print_debug(str(hit))
		if !penetrate_multiple_targets:
			destroy_projectile()
	total_distance += distance

func spawn_impact_effect(spawn_target: Node3D, spawn_position: Vector3, spawn_normal: Vector3, effect_scene: PackedScene):
	var effect = effect_scene.instantiate()
	#print("spawning impact")
	get_tree().root.add_child(effect)
	if effect is ImpactEffect:
		if effect.impact_decal != null:
			#print("adding decal")
			var decal = effect.impact_decal.instantiate()
			spawn_target.add_child(decal)
			decal.global_transform.origin = spawn_position
			decal.look_at(spawn_position - spawn_normal, Vector3.UP)
	#elif effect is Explosion:
		#effect.
	effect.top_level = true
	effect.global_transform.origin = spawn_position
	effect.spawn(spawn_position, spawn_normal)
	#effect.look_at(spawn_position - spawn_normal, Vector3.UP)
