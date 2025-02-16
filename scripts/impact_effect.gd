class_name ImpactEffect extends Node3D

@export var impact_sounds: Array[AudioStream]
@export var impact_particles: Array[GPUParticles3D]
@export var lifetime: float
@export var impact_decal: PackedScene
var audio_player: AudioStreamPlayer3D

func spawn(pos: Vector3, normal: Vector3):
	global_position = pos
	look_at(pos - normal, Vector3.UP)
	audio_player = $AudioStreamPlayer3D
	audio_player.stream = impact_sounds[randi_range(0, impact_sounds.size() - 1)]
	audio_player.play()
	$Timer.connect("timeout", cleanup)
	$Timer.start(lifetime)
	for particle in impact_particles:
		particle.restart()

func triggered(body, pos: Vector3, normal: Vector3):
	spawn(pos, normal)

func cleanup():
	queue_free()
