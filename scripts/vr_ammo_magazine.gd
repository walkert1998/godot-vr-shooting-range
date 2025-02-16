extends XRToolsPickable
class_name VRMagazine

@export var max_ammo_count: int = 10
@export var ammo_count: int = 10
@export var visible_bullets: Array[Node3D]

func has_bullets() -> bool:
	return ammo_count > 0

func use_ammo():
	ammo_count -= 1
	if visible_bullets.size() > 0:
		visible_bullets[ammo_count].hide()

func disable_collision():
	freeze = true
	$CollisionShape3D.disabled = true

func enable_collision():
	freeze = false
	$CollisionShape3D.disabled = false
