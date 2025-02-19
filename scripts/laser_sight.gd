extends RayCast3D

@export var laser_dot: Node3D

func _process(delta: float) -> void:
	if is_colliding():
		laser_dot.show()
		laser_dot.global_position = get_collision_point()
		#if get_collision_normal().dot(Vector3.UP) > 0.001:
			#laser_dot.look_at(get_collision_point() - get_collision_normal(), Vector3.UP)
	else:
		laser_dot.hide()
