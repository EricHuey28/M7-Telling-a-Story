class_name RocketLauncher extends Weapon_2

var _target: Mob_2 = null

@onready var _marker_2d: Marker2D = %Marker2D
@onready var _smoke_puff: GPUParticles2D = %SmokePuff


func _physics_process(_delta: float) -> void:
	if _target == null:
		_target = _find_closest_target()

	if _target != null:
		look_at(_target.global_position)


func _attack() -> void:
	#ANCHOR: L09_spawn_rocket
	if _target == null:
		return

	var rocket: Area2D = preload("projectiles/homing_rocket.tscn").instantiate()
	get_tree().current_scene.add_child(rocket)
	rocket.global_transform = _marker_2d.global_transform
	#END: L09_spawn_rocket

	#ANCHOR: L09_init_rocket
	rocket.target = _target
	rocket.damage = stats.damage
	#END: L09_init_rocket

	#ANCHOR: L09_spawn_particles
	_smoke_puff.restart()
	#END: L09_spawn_particles
