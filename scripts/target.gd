extends Node

@export var max_points: int = 500
@export var hit_sounds: Array[AudioStream]
@export var audio_player: AudioStreamPlayer3D
@export var animation_player: AnimationPlayer

func damage(amount: int) -> int:
	#var stream = hit_sounds[randi_range(0, hit_sounds.size())]
	#audio_player.stream = stream
	#audio_player.play()
	#hide()
	#hide()
	animation_player.play("Hide")
	return 1

func popup():
	animation_player.play("Popup")

func hide():
	animation_player.play("Hide")
