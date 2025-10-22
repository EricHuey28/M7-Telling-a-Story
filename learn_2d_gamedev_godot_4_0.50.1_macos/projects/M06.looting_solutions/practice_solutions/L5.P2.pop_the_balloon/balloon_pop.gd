extends Area2D


func _input_event(viewport: Viewport, event: InputEvent, shape_index: int):
	var event_is_mouse_release: bool = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_released() #
	)

	if event_is_mouse_release:
		queue_free()  # pass
