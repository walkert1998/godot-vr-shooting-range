extends Area3D

var active_hand: XRController3D
var active_pickup: XRToolsFunctionPickup
@export var object_to_spawn: PackedScene
@export var stash_sound: AudioStream
@export var grab_sound: AudioStream
@export var audio_player: AudioStreamPlayer3D

func _on_body_entered(body: Node3D) -> void:
	#print_debug(body)
	if body is XRController3D:
		active_hand = body as XRController3D
		active_hand.find_child("XRToolsRumbler").rumble()
		active_hand.connect("button_pressed", spawn_ammo)


func _on_body_exited(body: Node3D) -> void:
	if body == active_hand:
		active_hand = null
		active_hand.disconnect("button_pressed", spawn_ammo)

func spawn_ammo(button: String):
	print_debug(button)
	if button == "grip_click" && active_pickup:
		audio_player.stream = grab_sound
		audio_player.play()
		var new_ammo: VRMagazine = object_to_spawn.instantiate()
		get_tree().current_scene.add_child(new_ammo)
		#new_ammo.pick_up(active_pickup)
		active_pickup._pick_up_object(new_ammo)
		#new_ammo.connect("dropped", delete_unused_magazine)
		print_debug(new_ammo)

func delete_unused_magazine(magazine: XRToolsPickable):
	if get_overlapping_bodies().find(magazine) != -1:
		audio_player.stream = stash_sound
		audio_player.play()
		magazine.queue_free()


#func _on_area_entered(area: Area3D) -> void:
	#if area is XRToolsFunctionPickup:
		#active_hand = area.find_parent("*Hand") as XRController3D
		#active_hand.find_child("XRToolsRumbler").rumble()
		#active_hand.connect("button_pressed", spawn_ammo)
#
#
#func _on_area_exited(area: Area3D) -> void:
	#if area == active_hand:
		#active_hand = null
		#active_hand.disconnect("button_pressed", spawn_ammo)


func _on_area_entered(area: Area3D) -> void:
	#print_debug(area)
	if area.get_parent_node_3d() is XRToolsFunctionPickup:
		active_hand = area.find_parent("*Hand") as XRController3D
		active_pickup = active_hand.find_child("*FunctionPickup")
		active_hand.find_child("XRToolsRumbler").rumble()
		active_hand.connect("button_pressed", spawn_ammo)


func _on_area_exited(area: Area3D) -> void:
	if area.find_parent("*Hand") == active_hand:
		active_hand.disconnect("button_pressed", spawn_ammo)
		active_pickup = null
		active_hand = null
