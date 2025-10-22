extends Area2D

var _is_pressed := false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_is_pressed = event.pressed


func _process(_delta: float) -> void:
	if _is_pressed:
		global_position = get_global_mouse_position()
