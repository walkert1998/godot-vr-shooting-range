extends XRToolsInteractableAreaButton

signal toggle_on
signal toggle_off
@export var toggled: bool = false

func toggle(button: Variant):
	toggled = !toggled
	if toggled:
		emit_signal("toggle_on")
	else:
		emit_signal("toggle_off")
