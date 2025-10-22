# Places items at random positions on the screen.
extends Node2D

#ANCHOR: preload
var item_scenes := [
	preload("gem.tscn"),
	preload("health_pack.tscn")
]
#END: preload


#ANCHOR: _ready
func _ready() -> void:
	get_node("Timer").timeout.connect(_on_timer_timeout)
#END: _ready


#ANCHOR: _on_timer_timeout_definition
func _on_timer_timeout() -> void:
#END: _on_timer_timeout_definition
#ANCHOR: random_item_scene
	var random_item_scene: PackedScene = item_scenes.pick_random()
#END: random_item_scene
#ANCHOR: instantiate
	var item_instance := random_item_scene.instantiate()
	add_child(item_instance)
#END: instantiate

#ANCHOR: viewport_size
	var viewport_size := get_viewport_rect().size
#END: viewport_size
#ANCHOR: random_position
	var random_position := Vector2(0.0, 0.0)
	random_position.x = randf_range(0.0, viewport_size.x)
	random_position.y = randf_range(0.0, viewport_size.y)
#END: random_position
#ANCHOR: set_position
	item_instance.position = random_position
#END: set_position
