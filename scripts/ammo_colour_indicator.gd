extends Node

@export var mesh: MeshInstance3D
@export var current_colour: Color
@export var colour_gradient: Gradient
var parent_weapon: VRRangedWeapon
var current_ammo: int = 0
var max_ammo: int = 1

func _ready() -> void:
	parent_weapon = get_parent()
	if parent_weapon.magazine:
		current_ammo = parent_weapon.magazine.ammo_count
		max_ammo = parent_weapon.magazine.max_ammo_count
	update_colour(parent_weapon)

func update_colour(pickable):
	if parent_weapon.magazine:
		current_ammo = parent_weapon.magazine.ammo_count
		max_ammo = parent_weapon.magazine.max_ammo_count
	else:
		current_ammo = 0
		max_ammo = 1
	#print(float(current_ammo) / float(max_ammo))
	mesh.get_surface_override_material(0).emission = colour_gradient.sample(float(current_ammo) / float(max_ammo))
	current_colour = mesh.get_surface_override_material(0).emission
