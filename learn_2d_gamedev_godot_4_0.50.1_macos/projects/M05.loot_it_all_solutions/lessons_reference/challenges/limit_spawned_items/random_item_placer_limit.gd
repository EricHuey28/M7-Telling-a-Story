extends Node2D

var item_scenes := [preload("gem.tscn"), preload("health_pack.tscn")]

var item_count := 0


func _ready() -> void:
	get_node("Timer").timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	if item_count == 6:
		return

	var random_item_scene: PackedScene = item_scenes.pick_random()
	var item_instance := random_item_scene.instantiate()
	add_child(item_instance)

	var viewport_size := get_viewport_rect().size
	var random_position := Vector2(0.0, 0.0)
	random_position.x = randf_range(0.0, viewport_size.x)
	random_position.y = randf_range(0.0, viewport_size.y)
	item_instance.position = random_position

	item_instance.tree_exited.connect(_on_item_instance_tree_exited)
	item_count += 1


func _on_item_instance_tree_exited() -> void:
	item_count -= 1
