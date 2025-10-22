class_name SimpleCannon extends Weapon

@onready var _spawn_point: Marker2D = %RocketSpawnPoint


func _physics_process(_delta: float) -> void:
	var mobs_in_range := _area_2d.get_overlapping_areas()
	if not mobs_in_range.is_empty():
		var target: Area2D = mobs_in_range.front()
		look_at(target.global_position)


func _attack() -> void:
	var mobs_in_range := _area_2d.get_overlapping_areas()
	if mobs_in_range.is_empty():
		return

	var rocket: Node2D = preload("projectiles/simple_rocket.tscn").instantiate()
	get_tree().current_scene.add_child(rocket)
	rocket.global_transform = _spawn_point.global_transform
