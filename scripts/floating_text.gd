extends Node

@export var label: Label3D
@export var animation_player: AnimationPlayer

func show_text(text: String):
	label.text = text
	animation_player.play("Fade")
