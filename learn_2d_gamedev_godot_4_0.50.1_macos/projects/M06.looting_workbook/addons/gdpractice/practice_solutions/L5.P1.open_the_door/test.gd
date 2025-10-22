extends "res://addons/gdpractice/tester/test.gd"

var practice_chests: Array = []
var solution_chests: Array = []


func _setup_state() -> void:
	practice_chests = _practice.find_children("", "Area2D")
	solution_chests = _solution.find_children("", "Area2D")

func _build_checks() -> void:
	_add_simple_check(
		tr("The door's open animation plays when the player clicks on the door."),
		func() -> String:
			var result := ""
			var left_click_event := InputEventMouseButton.new()
			left_click_event.button_index = MOUSE_BUTTON_LEFT
			left_click_event.pressed = true
			var areas := practice_chests + solution_chests
			for idx in range(areas.size()):
				var area: Area2D = areas[idx]
				area._input_event(get_viewport(), left_click_event, 0)
				if idx == 0:
					var hint := tr("Did you forget to call animation_player.play() with the door's open animation?")
					result = "" if area.animation_player.current_animation == "open" and area.animation_player.is_playing() else hint
			return result
	)

	var check_input_pickable := Check.new()
	var description: Array[String] = [
		"After clicking on the door, the door's input_pickable property is set to false",
		"to prevent the player from clicking on it again."
	]
	check_input_pickable.description = tr(" ".join(description))
	check_input_pickable.checker = func() -> String:
		var result := ""
		for practice_chest: Area2D in practice_chests:
			var hint := tr("Did you forget to set the door's input_pickable property?")
			result = "" if not practice_chest.input_pickable else hint
		return result
	check_input_pickable.dependencies += [checks.back()]

	checks += [check_input_pickable]
