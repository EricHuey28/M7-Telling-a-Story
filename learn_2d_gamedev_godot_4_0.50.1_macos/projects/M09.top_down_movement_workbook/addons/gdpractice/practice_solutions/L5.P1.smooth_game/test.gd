extends "res://addons/gdpractice/tester/test.gd"

class TestResult:
	var expected := 0.0
	var actual := 0.0

	func _init(init_expected: float, init_actual: float) -> void:
		expected = init_expected
		actual = init_actual

	func is_equal() -> bool:
		return abs(expected - actual) < 0.1

	func _to_string():
		return "(expected: %s, actual :%s)"%[expected, actual]

var _practice_ship: CharacterBody2D
var _solution_ship: CharacterBody2D
var _velocity_rising_results: Array[TestResult] = []
var _velocity_stopped_results: Array[TestResult] = []
var _rotation_results: Array[TestResult] = []


func _build_requirements() -> void:
	var node_name := "SmoothShip"
	_practice_ship = _practice.get_node_or_null(node_name)
	_solution_ship = _solution.get_node(node_name)
	_add_callable_requirement(
		tr("There should be an '%s' node")%[node_name],
		func() -> String:
			if not _practice_ship:
				return tr("There is no '%s' node. Did you remove it? It's required for the practice to work")%[node_name]
			return ""
	)


func _setup_state() -> void:
	_solution_ship.max_speed = _practice_ship.max_speed
	_solution_ship.acceleration = _practice_ship.acceleration
	_solution_ship.deceleration = _practice_ship.deceleration
	_solution_ship.rotation_speed = _practice_ship.rotation_speed


func _setup_populate_test_space() -> void:
	const KEY_TO_TEST = &"move_left"
	Input.action_press(KEY_TO_TEST)
	await _connect_timed(1.5,
		get_tree().physics_frame,
		func() -> void:
			_velocity_rising_results.append(
				TestResult.new(
					_solution_ship.velocity.length(),
					_practice_ship.velocity.length()
				)
			)
			_rotation_results.append(
				TestResult.new(
					_solution_ship.rotation,
					_practice_ship.rotation
				)
			)
	)

	Input.action_release(KEY_TO_TEST)

	var current_velocity := Vector2.LEFT * 20.0
	_solution_ship.velocity = current_velocity
	_practice_ship.velocity = current_velocity

	await _connect_timed(0.2,
		get_tree().physics_frame,
		func() -> void:
			_velocity_stopped_results.append(
				TestResult.new(
					_solution_ship.velocity.length(),
					_practice_ship.velocity.length()
				)
			)
	)

func _build_checks() -> void:
	_add_simple_check(tr("Velocity increases gradually"), _test_velocity_increases_gradually)
	_add_simple_check(tr("Velocity decreases gradually"), _test_velocity_decreases_gradually)
	var rotation_uses_correct_angle := _add_simple_check(tr("Rotation uses the correct angle"), _test_rotation_accounts_for_angle)
	var rotation_increases :=  _add_simple_check(tr("Rotation increases gradually"), _test_rotation_increases_gradually)
	rotation_increases.dependencies = [rotation_uses_correct_angle]


func _test_velocity_increases_gradually() -> String:
	for result in _velocity_rising_results:
		if not result.is_equal():
			return tr("It seems your ship isn't increasing its velocity over time. Did you use `move_toward()`?")
	return ''


func _test_velocity_decreases_gradually() -> String:
	for result in _velocity_stopped_results:
		if not result.is_equal():
			return tr("It seems your ship isn't decreasing its velocity over time. Did you use `move_toward()`?")
	return ''


func _test_rotation_increases_gradually() -> String:
	for result in _rotation_results:
		if not result.is_equal():
			return tr("It seems your ship isn't increasing its rotation over time. Did you use `rotate_toward()`?")
	return ''


func _test_rotation_accounts_for_angle() -> String:
	for test_result: TestResult in _rotation_results:
		if not is_equal_approx(test_result.expected, test_result.actual):
			return tr("It seems your ship isn't rotated correctly. Did you make sure to use `orthogonal()`?")
	return ''
