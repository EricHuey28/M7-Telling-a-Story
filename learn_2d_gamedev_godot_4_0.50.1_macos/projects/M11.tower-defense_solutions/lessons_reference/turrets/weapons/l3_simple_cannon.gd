class_name SimpleCannon_L3 extends Weapon

@onready var _spawn_point: Marker2D = %RocketSpawnPoint

func _physics_process(_delta: float) -> void:
	#ANCHOR: look_at_mob
	var mobs_in_range := _area_2d.get_overlapping_areas()
	if not mobs_in_range.is_empty():
		var target: Area2D = mobs_in_range.front()
		look_at(target.global_position)
		#END: look_at_mob
	#ANCHOR: temp_move_mob
	$Mob.global_position = get_global_mouse_position()
	#END: temp_move_mob


func _attack() -> void:
	#ANCHOR: _attack_top
	var mobs_in_range := _area_2d.get_overlapping_areas()
	if mobs_in_range.is_empty():
		return

	var rocket: Node2D = preload("projectiles/simple_rocket.tscn").instantiate()
	get_tree().current_scene.add_child(rocket)
	#END: _attack_top
	#ANCHOR:attack_bottom
	rocket.global_transform = _spawn_point.global_transform
	#END:attack_bottom
