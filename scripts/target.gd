extends Node
class_name RangeTarget

signal on_hit(string)

@export var max_points: int = 500
@export var hit_sounds: Array[AudioStream]
@export var audio_player: AudioStreamPlayer3D
@export var animation_player: AnimationPlayer
@export var colliders: Array[CollisionShape3D]
@export var target_up: bool = false

func damage(amount: int) -> int:
	#var stream = hit_sounds[randi_range(0, hit_sounds.size())]
	#audio_player.stream = stream
	#audio_player.play()
	#hide()
	#hide()
	var points: int = max_points
	hide()
	audio_player.play()
	emit_signal("on_hit", str(points))
	return 1

func popup():
	for collider in colliders:
		collider.set_deferred("disabled", false)
	animation_player.play("Popup")
	target_up = true

func hide():
	target_up = false
	animation_player.play("Hide")
	for collider in colliders:
		collider.set_deferred("disabled", true)
