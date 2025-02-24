class_name RangedWeapon extends Item

@export var clip_size: int
@export var time_between_shots: float
@export var reload_time: float
# If TRUE, weapon reloads one ammo at a time
@export var single_reload: bool
@export var bullet_spread_angle: float = 0
@export var projectiles_per_shot: int = 1
@export var projectile_scene: PackedScene
@export var recoil: float
@export var icon: Texture2D
@export var weapon_view_model: PackedScene
@export var attack_sounds: Array[AudioStream]
@export var low_ammo_attack_sounds: Array[AudioStream]
@export var slide_pull_sound: AudioStream
@export var slide_release_sound: AudioStream
@export var load_magazine_sound: AudioStream
@export var drop_magazine_sound: AudioStream
@export var dry_fire_sound: AudioStream
@export var ammo_types: Array[Ammo]
@export var loaded_ammo_type: Ammo
@export var loaded_ammo_count: int
@export var recoil_rotation_x: Curve
@export var recoil_rotation_z: Curve
@export var recoil_position_z: Curve
@export var zoomed_in_fov: float = 60.0
