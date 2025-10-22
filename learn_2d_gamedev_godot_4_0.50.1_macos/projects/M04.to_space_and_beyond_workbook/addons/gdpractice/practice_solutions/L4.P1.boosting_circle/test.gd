extends "res://addons/gdpractice/tester/test.gd"


const INPUTS_TO_TEST := [
	[&"move_right"],
	[&"move_right", &"move_up"],
	[&"move_up"],
	[&"move_left", &"move_up"],
	[&"move_left"],
	[&"move_left", &"move_down"],
	[&"move_down"],
	[&"move_right", &"move_down"],
]

var speed_after_boost_start := 0.0
var is_timer_started_on_boost := false
var is_on_timer_timeout_defined := false
var is_timer_connected_to_on_timer_timeout := false
var is_timer_one_shot := false
var speed_after_boost_end := 0.0


func _setup_state() -> void:
	if _practice.max_speed > 0.0:
		_solution.max_speed = _practice.max_speed


func _setup_populate_test_space() -> void:
	# Test the scene and gather information
	# First with the timer node
	var timer: Timer = (func find_timer_child() -> Timer:
		for node in _practice.find_children("*", "Timer"):
			if node is Timer:
				return node
		return null
	).call()
	if timer != null:
		is_on_timer_timeout_defined = _practice.has_method("_on_timer_timeout")
		is_timer_one_shot = timer.one_shot
		if is_on_timer_timeout_defined:
			is_timer_connected_to_on_timer_timeout = timer.timeout.is_connected(_practice._on_timer_timeout)
			timer.timeout.connect(func store_speed_after_timeout() -> void:
				await get_tree().process_frame
				speed_after_boost_end = _practice.max_speed
			)

	# Boost the ship, then move in a "circle"
	Input.action_press("boost")
	await get_tree().process_frame
	speed_after_boost_start = _practice.max_speed
	if timer != null:
		is_timer_started_on_boost = not timer.is_stopped()
	Input.action_release("boost")
	for action_list in INPUTS_TO_TEST:
		for action in action_list:
			Input.action_press(action)
		await get_tree().create_timer(0.3).timeout
		for action in action_list:
			Input.action_release(action)


func _build_requirements() -> void:
	_add_actions_requirement(Utils.flatten_unique(INPUTS_TO_TEST) + ["boost"])


func _build_checks() -> void:
	_add_simple_check(tr("Pressing the boost input increases max speed"), _test_pressing_the_boost_input_increases_max_speed)
	_add_simple_check(tr("Timer is one-shot"), _test_is_timer_one_shot)
	_add_simple_check(tr("Boost input starts timer"), _test_boost_input_starts_timer)
	_add_simple_check(tr("Timer timeout signal is connected"), _test_timer_timeout_signal_is_connected)
	_add_simple_check(tr("Timer timeout restores normal speed"), _test_timer_timeout_restores_normal_speed)


func _test_pressing_the_boost_input_increases_max_speed() -> String:
	if is_equal_approx(speed_after_boost_start, _practice.normal_speed):
		return tr("It appears that the ship's speed was still equal to normal_speed after pressing the boost input. Did you forget to increase the ship's speed? It should be set to `boost_speed`.")
	elif speed_after_boost_start != _practice.boost_speed:
		return tr("It appears that the ship's speed was not equal to boost_speed after pressing the boost input. Did you forget to increase the ship's speed? It should be set to `boost_speed`.")
	return ''


func _test_boost_input_starts_timer() -> String:
	if not is_timer_started_on_boost:
		return tr("The Timer node is not started when the boost input is pressed. Did you forget to start it?")
	return ''


func _test_timer_timeout_signal_is_connected() -> String:
	if not is_timer_connected_to_on_timer_timeout:
		return tr("The Timer node's timeout signal is not connected to the `_on_timer_timeout()` function. Did you forget to connect it?")
	return ''


func _test_is_timer_one_shot() -> String:
	if not is_timer_one_shot:
		return tr("The Timer node is not set to one-shot mode, so it will cycle infinitely. Did you forget to set it?")
	return ''


func _test_timer_timeout_restores_normal_speed() -> String:
	if is_equal_approx(speed_after_boost_end, _practice.boost_speed):
		return tr("The ship's speed was still equal to boost_speed after the timer timed out. Did you forget to restore the ship's speed? It should be set to `normal_speed`.")
	elif speed_after_boost_end != _practice.normal_speed:
		return tr("It appears that the ship's speed was not equal to normal_speed after the timer timed out. Did you forget to restore the ship's speed? It should be set to `normal_speed`.")
	return ''
