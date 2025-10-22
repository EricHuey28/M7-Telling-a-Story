extends "res://addons/gdpractice/tester/test.gd"

func _build_requirements() -> void:
	_add_callable_requirement(
		"There should be a variable named 'lines' of type String",
		func() -> String:
			if not "lines" in _practice:
				return tr("There is no 'lines' variable. Did you remove it? It's required for the practice to work")
			var lines_in_practice := (_practice.lines as String).strip_edges()
			var lines_in_solution := (_solution.lines as String).strip_edges()
			if lines_in_practice.length() != lines_in_solution.length():
				return tr("It looks like the 'lines' variable string has been modified. Please make sure you use the original string!")
			return ""
	)
	_add_callable_requirement(
		"There should be a variable named 'appearance_time' of type float",
		func() -> String:
			if not "appearance_time" in _practice or not (_practice.appearance_time is float):
				return tr("There is no 'appearance_time' number. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"The code should not use get_tree().create_tween() to create the tween",
		func() -> String:
			if _is_code_line_match(["*get_tree().create_tween*"]):
				return tr("It looks like you're using get_tree().create_tween() to create the tween. Please call create_tween() directly without getting the SceneTree object first. Otherwise, the practice won't be able to test your code.")
			return ""
	)

var _initial_visible_ratio := 0.0
var _measured_visible_ratio := 0.0
var _expected_visible_ratio := 0.0

func _setup_populate_test_space() -> void:
	# Normalize the strings to remove any leading/trailing whitespace to any line
	for node in [_practice, _solution]:
		var lines: Array = Array(node.lines.strip_edges().split("\n")).map(func(line: String) -> String:
			return line.strip_edges()
		)
		node.lines = "\n".join(lines)

	_initial_visible_ratio = (_practice.rich_text_label as RichTextLabel).visible_ratio
	var time_ratio := 10.0
	var duration: float = _practice.appearance_time / time_ratio
	# We need to wait a little longer than the appearance time divided by a
	# ratio; there is an edge case where students can get the animation to go at
	# the right pace but end early.
	await get_tree().create_timer(duration + 0.25).timeout
	_measured_visible_ratio = (_practice.rich_text_label as RichTextLabel).visible_ratio
	_expected_visible_ratio = (_solution.rich_text_label as RichTextLabel).visible_ratio

func _build_checks() -> void:
	var visible_ratio_is_set_to_zero := Check.new()
	visible_ratio_is_set_to_zero.description = tr("The text visible ratio is set to zero")

	visible_ratio_is_set_to_zero.checker = func() -> String:
		if not is_zero_approx(_initial_visible_ratio):
			return "The rich text label's visibility ratio is not set to zero before tweening. We expected '0.0', we got '%s'"%[_practice.rich_text_label.visible_ratio]
		return ""

	var visible_ratio_is_tweened := Check.new()
	visible_ratio_is_tweened.description = tr("The text visible ratio is tweened to 1")

	visible_ratio_is_tweened.checker = func() -> String:
		var tweens := get_tree().get_processed_tweens()
		var valid_tweens: Array[Tween] = []
		for tween in tweens:
			var bound_node_name := str(tween).split("(bound to ")[1].rstrip(")")
			if bound_node_name == _solution.name:
				valid_tweens.append(tween)
		if valid_tweens.size() < 2:
			return "There are no tweens running in the scene, or the tween isn't tweening anything? Did you create a tween and made it tween a property?"
		if not is_equal_approx(_measured_visible_ratio, _expected_visible_ratio):
			return "It doesn't look like the visible ratio is tweened to its final value. Did you tween it to 1?"
		return ""

	var stream_does_play := Check.new()
	stream_does_play.description = tr("The sound stream starts")

	stream_does_play.checker = func() -> String:
		var audio_stream_player := _practice.audio_stream_player as AudioStreamPlayer
		if not audio_stream_player.playing:
			return "It doesn't seem like the audio player is started. Did you use `.play()`?"
		return ""

	var stream_does_stop := Check.new()
	stream_does_stop.description = tr("The sound stream stops")

	stream_does_stop.checker = func() -> String:
		var audio_stream_player := _practice.audio_stream_player as AudioStreamPlayer
		var tweens := get_tree().get_processed_tweens()
		var valid_tweens: Array[Tween] = []
		for tween in tweens:
			var bound_node_name := str(tween).split("(bound to ")[1].rstrip(")")
			if bound_node_name == _solution.name:
				valid_tweens.append(tween)
		if valid_tweens.size() < 2:
			return "There are no tweens running in the scene, or the tween isn't tweening anything? Did you create a tween and made it tween a property?"
		for tween in valid_tweens:
			if tween.finished.is_connected(audio_stream_player.stop):
				return ""
		return "It doesn't seem like the tween stops the audio player when it finishes. Did you connect the signal?"

	checks = [visible_ratio_is_set_to_zero, visible_ratio_is_tweened, stream_does_play, stream_does_stop]
