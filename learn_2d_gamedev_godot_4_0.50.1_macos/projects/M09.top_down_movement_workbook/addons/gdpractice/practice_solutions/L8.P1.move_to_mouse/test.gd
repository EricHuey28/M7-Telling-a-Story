extends "res://addons/gdpractice/tester/test.gd"

class FloatTestResult:
	var expected := 0.0
	var actual := 0.0
	
	func _init(init_expected: float, init_actual: float) -> void:
		expected = init_expected
		actual = init_actual
	
	func is_equal() -> bool:
		return abs(expected - actual) < 0.1
		
	func _to_string():
		return "(expected: %s, actual :%s)"%[expected, actual]

class PositionTestResult:
	var expected := Vector2.ZERO
	var actual := Vector2.ZERO
	
	func _init(init_expected: Vector2, init_actual: Vector2) -> void:
		expected = init_expected
		actual = init_actual
	
	func is_equal() -> bool:
		return expected.is_equal_approx(actual)
		
	func _to_string():
		return "(expected: %s, actual :%s)"%[expected, actual]

var _practice_ship: CharacterBody2D
var _solution_ship: CharacterBody2D
var _practice_cursor: Area2D
var _solution_cursor: Area2D
var _position_results: Array[PositionTestResult] = []
var _rotation_results: Array[FloatTestResult] = []
var _distance_results: Array[FloatTestResult] = []
var _direction_results: Array[PositionTestResult] = []
var _duration_results: Array[FloatTestResult] = []


func _build_requirements() -> void:
	var node_name := "MouseShip"
	_practice_ship = _practice.get_node_or_null(node_name)
	_solution_ship = _solution.get_node(node_name)
	_add_callable_requirement(
		tr("There should be an '%s' node")%[node_name],
		func() -> String: 
			if not _practice_ship:
				return tr("There is no '%s' node. Did you remove it? It's required for the practice to work")%[node_name]
			return ""
	)
	var cursor_node_name := "Cursor"
	_practice_cursor = _practice.get_node_or_null(cursor_node_name)
	_solution_cursor = _solution.get_node(cursor_node_name)
	_add_callable_requirement(
		tr("There should be an '%s' node")%[cursor_node_name],
		func() -> String: 
			if not _practice_ship:
				return tr("There is no '%s' node. Did you remove it? It's required for the practice to work")%[node_name]
			return ""
	)


func _setup_state() -> void:
	_solution_ship.max_speed = _practice_ship.max_speed
	_solution_ship.global_position = _practice_ship.global_position
	_solution_ship.distance = _practice_ship.distance
	_solution_ship.direction = _practice_ship.direction
	_solution_ship.duration = _practice_ship.duration
	_solution_ship.rotation = _practice_ship.rotation


func _setup_populate_test_space() -> void:
	
	var start_position: Vector2 = _solution_ship.global_position
	for offset: Vector2 in [
		Vector2(0, 200),
		Vector2(-100, -100),
		Vector2(100, -100),
		Vector2(100, 100),
		Vector2(-100, 100),
	]:
		var target_position := start_position + offset
		_practice_cursor.global_position = target_position
		_solution_cursor.global_position = target_position
		
		_solution_ship.walk_to(_solution_cursor.global_position)
		_practice_ship.walk_to(_practice_cursor.global_position)
		
		await _connect_timed(0.5, 
			get_tree().physics_frame, 
			func() -> void:
				_position_results.append(
					PositionTestResult.new(
						_solution_ship.global_position,
						_practice_ship.global_position
					)
				)
				_rotation_results.append(
					FloatTestResult.new(
						_solution_ship.rotation,
						_practice_ship.rotation
					)
				)
				_distance_results.append(
					FloatTestResult.new(
						_solution_ship.distance,
						_practice_ship.distance
					)
				)
				_direction_results.append(
					PositionTestResult.new(
						_solution_ship.direction,
						_practice_ship.direction
					)
				)
				_duration_results.append(
					FloatTestResult.new(
						_solution_ship.duration,
						_practice_ship.duration
					)
				)
		)


func _build_checks() -> void:
	_add_simple_check(tr("The ship moves towards the mouse"), _test_position)
	_add_simple_check(tr("The distance is calculated correctly"), _test_distance)
	_add_simple_check(tr("The direction is calculated correctly"), _test_direction)
	_add_simple_check(tr("The tween lasts the expected amount of time"), _test_duration)


func _test_position() -> String:
	for result in _position_results:
		if not result.is_equal():
			return tr("It seems your ship isn't moving towards the mouse. Are you sure the calculated duration is correct?")
	return ''


func _test_distance() -> String:
	for test_result in _distance_results:
		if not test_result.is_equal():
			return tr("It seems the distance you calculated isn't correct. Did you use the function Vector2.distance_to() to calculate the distance?")
	return ''


func _test_direction() -> String:
	for test_result in _direction_results:
		if not test_result.is_equal():
			return tr("It seems your direction property is incorrect. Are you using Vector2.direction_to() to calculate the direction?")
	return ''


func _test_duration() -> String:
	for test_result in _duration_results:
		if not test_result.is_equal():
			return tr("It seems the duration is incorrect. Are you dividing the distance by max_speed?")
	return ''
