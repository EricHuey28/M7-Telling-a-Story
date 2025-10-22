## Basic weapon that shoots a simple bullet, targets one mob, and instantly
## damages it.
#ANCHOR:class_name
class_name SimpleCannon extends Weapon
#END:class_name

var _target: Mob = null

@onready var _spawn_point: Marker2D = %RocketSpawnPoint


func _physics_process(_delta: float) -> void:
	if _target == null:
		_target = _find_closest_target()

	if _target == null:
		return

	#ANCHOR:rotate_toward_target
	_rotate_toward_target(_target)
	#END:rotate_toward_target


func _attack() -> void:
	#ANCHOR:instantiate_and_place_rocket
	if _target == null:
		return
	var rocket: Node2D = preload("projectiles/simple_rocket.tscn").instantiate()
	get_tree().current_scene.add_child(rocket)
	rocket.global_transform = _spawn_point.global_transform
	#END:instantiate_and_place_rocket
