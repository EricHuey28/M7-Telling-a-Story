extends Sprite2D

@export var follow_weight := 0.1

func _process(_delta: float) -> void:
	var _cursor_main := get_parent() as Node2D
	global_position = global_position.lerp(_cursor_main.global_position, follow_weight)
	rotation = global_position.angle_to(_cursor_main.global_position)
