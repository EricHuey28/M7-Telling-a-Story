## Basic weapon that shoulds a simple bullet, targets one mob, and instantly
## damages it.
#ANCHOR:class_name
class_name SimpleCannon_2 extends Weapon_2
#END:class_name

@onready var _spawn_point: Marker2D = %RocketSpawnPoint


func _physics_process(_delta: float) -> void:
	var mobs_in_range := _area_2d.get_overlapping_areas()
	if not mobs_in_range.is_empty():
		var target: Area2D = mobs_in_range.front()
		look_at(target.global_position)


func _attack() -> void:
	#ANCHOR: L06_M11_code
	var mobs_in_range := _area_2d.get_overlapping_areas()
	if mobs_in_range.is_empty():
		return

	var rocket: Node2D = preload("projectiles/simple_rocket.tscn").instantiate()
	get_tree().current_scene.add_child(rocket)
	rocket.global_transform = _spawn_point.global_transform
	#END: L06_M11_code
	#ANCHOR: L06_damage
	rocket.damage = stats.damage
	#END: L06_damage
