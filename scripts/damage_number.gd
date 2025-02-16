extends Node

func display_number(value: int, position: Vector3, is_critical: bool = false):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	if is_critical:
		color = "#B22"
	if value == 0:
		color = "#FFF8"
	
	number.label_settings.font_color = color
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)
