class_name ImpactEffect extends Node3D

@export var impact_sounds: Array[AudioStream]
@export var impact_particles: Array[GPUParticles3D]
@export var lifetime: float = 10
@export var impact_decal: PackedScene
@export var impact_sprites: Array[Sprite3D]
var audio_player: AudioStreamPlayer3D

func spawn(pos: Vector3, normal: Vector3):
	#print(str(pos) + " " + str(normal))
	top_level = true
	global_transform.origin = pos
	var sprite = impact_sprites[randi_range(0, impact_sprites.size() - 1)]
	sprite.show()
	print(transform)
	look_at(pos - normal, Vector3.UP)
	print(transform)
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
