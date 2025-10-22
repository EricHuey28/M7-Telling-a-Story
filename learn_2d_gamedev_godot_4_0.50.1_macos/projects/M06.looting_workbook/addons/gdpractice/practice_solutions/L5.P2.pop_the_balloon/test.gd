extends "res://addons/gdpractice/tester/test.gd"

var balloon_pop: Area2D = _load("balloon_pop.gd", true).new()

func _build_checks() -> void:

	var check_left_click_press_fails := Check.new()
	check_left_click_press_fails.description = tr("The balloon is not freed when the player presses down the left mouse button")
	check_left_click_press_fails.checker = func() -> String:
		var result := ""
		var left_click_event := InputEventMouseButton.new()
		left_click_event.button_index = MOUSE_BUTTON_LEFT
		left_click_event.pressed = true
		balloon_pop._input_event(get_viewport(), left_click_event, 0)
		var message := tr("The balloon should not be freed when the player presses down the left mouse button. Did you forget to check that the mouse button is released?")
		result = "" if not balloon_pop.is_queued_for_deletion() else message
		return result


	var check_left_click_release := Check.new()
	check_left_click_release.description = tr("When the player releases a left mouse click on the balloon, the balloon is freed.")
	check_left_click_release.checker = func() -> String:
		var result := ""
		var left_click_event := InputEventMouseButton.new()
		left_click_event.button_index = MOUSE_BUTTON_LEFT
		left_click_event.pressed = false
		balloon_pop._input_event(get_viewport(), left_click_event, 0)
		var message := tr("The balloon should be freed when the player releases the left mouse button. Did you forget to call the queue_free() function or to check that the mouse button is released?")
		result = "" if balloon_pop.is_queued_for_deletion() else message
		return result
	check_left_click_release.dependencies += [check_left_click_press_fails]

	checks += [check_left_click_press_fails, check_left_click_release]
