extends "res://addons/gdpractice/tester/test.gd"

var expected_shader := _load("group_outline.gdshader", true)

var practice_balloon: Area2D = null
var practice_canvas_group: CanvasGroup = null
var practice_material: Material = null


func _setup_state() -> void:
	for area: Area2D in _practice.find_children("", "Area2D"):
		practice_balloon = area

	for canvas_group: CanvasGroup in _practice.find_children("", "CanvasGroup"):
		practice_canvas_group = canvas_group
		practice_material = practice_canvas_group.material


func _build_checks() -> void:
	var check_material_is_present := _add_simple_check(
		tr("The balloon's CanvasGroup node has a material with the provided group_outline.gdshader shader applied to it."),
		func() -> String:
			var has_outline_shader: bool = practice_material != null and practice_material.shader.resource_path == expected_shader.resource_path
			if not has_outline_shader:
				if practice_material != null and not "practices/" in practice_material.shader.resource_path:
					return tr("The CanvasGroup node's Material property has a shader assigned to it, but it's not the shader provided in the practice folder. Please make sure that you did not apply a shader from the lessons folder or another location in the project.")
				else:
					return tr("Did you assign the provided group_outline.gdshader to the CanvasGroup node's Material property?")
			return ""
	)

	var check_mouse_signals := Check.new()
	check_mouse_signals.description = tr("The mouse_entered and mouse_exited signals are connected properly.")

	var check_mouse_entered := Check.new()
	check_mouse_entered.description = tr("The mouse_entered signal is connected to the _on_mouse_entered() function.")
	check_mouse_entered.checker =  func() -> String:
		var has_mouse_entered_signal := practice_balloon != null and practice_balloon.mouse_entered.is_connected(practice_balloon._on_mouse_entered)
		return "" if has_mouse_entered_signal else tr("The mouse_entered signal is not connected to the _on_mouse_entered() function. Please make sure to connect the signal to _on_mouse_entered in the _ready() function.")

	var check_mouse_exited := Check.new()
	check_mouse_exited.description = tr("The mouse_exited signal is connected to the _on_mouse_exited() function.")
	check_mouse_exited.checker = func() -> String:
		var has_mouse_exited_signal := practice_balloon != null and practice_balloon.mouse_exited.is_connected(practice_balloon._on_mouse_exited)
		return "" if has_mouse_exited_signal else tr("The mouse_exited signal is not connected to the _on_mouse_exited() function. Please make sure to connect the signal to _on_mouse_exited in the _ready() function.")

	check_mouse_signals.subchecks += [check_mouse_entered, check_mouse_exited]

	var check_interaction := Check.new()
	check_interaction.description = tr("The mouse interacts with the balloon")
	check_interaction.dependencies = [check_material_is_present]

	var check_mouse_hovers := Check.new()
	check_mouse_hovers.description = tr("When the mouse hovers over the balloon, the outline grows instantly to 10 pixels thick.")
	check_mouse_hovers.checker = func() -> String:
		var hint := tr("Did you call the set_outline_thickness() function in _on_mouse_entered() with the correct thickness value?")
		if practice_material == null:
			return hint

		practice_balloon._on_mouse_entered()
		return "" if is_equal_approx(practice_material.get_shader_parameter("line_thickness"), 10.0) else hint

	var check_mouse_exits := Check.new()
	check_mouse_exits.description = tr("When the mouse exits the balloon, the outline shrinks instantly to 5 pixels thick.")
	check_mouse_exits.checker = func() -> String:
		var hint := tr("Did you call the set_outline_thickness() function in _on_mouse_exited() with the correct thickness value?")
		if practice_material == null:
			return hint

		practice_balloon._on_mouse_exited()
		return "" if is_equal_approx(practice_material.get_shader_parameter("line_thickness"), 5.0) else hint

	check_interaction.subchecks += [check_mouse_hovers, check_mouse_exits]
	check_interaction.dependencies += [check_mouse_signals]

	checks += [check_mouse_signals, check_interaction]
