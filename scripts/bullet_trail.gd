class_name BulletTrail extends MeshInstance3D

var alpha: float = 1.0
@export var timer: Timer
@export var blood_impact: ImpactEffect
@export var dirt_impact: ImpactEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	var dup_mat = material_override.duplicate()
	material_override = dup_mat
	timer.connect("timeout", timeout)
	timer.start(1.5)


func draw(pos1: Vector3, pos2: Vector3):
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material_override)
	draw_mesh.surface_add_vertex(pos1)
	draw_mesh.surface_add_vertex(pos2)
	draw_mesh.surface_end()

func draw_impact(on_enemy: bool, pos: Vector3, normal: Vector3):
	if on_enemy:
		blood_impact.spawn(pos, normal)
	#else:
		#dirt_impact.spawn(pos, normal)
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	alpha -= delta * 3.5
	material_override.albedo_color.a = alpha

func timeout():
	queue_free()
