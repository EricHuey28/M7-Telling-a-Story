extends "res://addons/gdpractice/tester/test.gd"

var _external_walls: StaticBody2D
var _collision_polygon_node: CollisionPolygon2D
var _points := PackedVector2Array()
var _solution_points := PackedVector2Array()


func _build_requirements() -> void:
	_external_walls = _practice.get_node_or_null("ExternalWallsStaticBody2D")
	if _external_walls != null:
		_collision_polygon_node = _external_walls.get_node_or_null("CollisionPolygon2D")
	if _collision_polygon_node != null:
		_points = _collision_polygon_node.polygon
	_solution_points = PackedVector2Array([
		Vector2(1792, -960),
		Vector2(-1792, -960),
		Vector2(-1792, 960),
		Vector2(1792, 960)
	])

	_add_callable_requirement(
		"There should be an 'ExternalWallsStaticBody2D' node",
		func() -> String:
			if not _external_walls:
				return tr("There is no 'ExternalWallsStaticBody2D' node. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"There should be a collision polygon called 'CollisionPolygon2D' as a child of 'ExternalWallsStaticBody2D'",
		func() -> String:
			if not _collision_polygon_node:
				return tr("There is no 'CollisionPolygon2D' node. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"The nodes should not be offset, rotated, or scaled",
		func() -> String:
			if not _collision_polygon_node or not _external_walls:
				return ""

			if not _external_walls.position.is_zero_approx():
				return tr("The ExternalWallsStaticBody2D node is offset from its original position. Please reset its position")
			if not is_zero_approx(_external_walls.rotation):
				return tr("The ExternalWallsStaticBody2D node is rotated. Please reset its rotation to 0")
			if not _external_walls.scale.is_equal_approx(Vector2.ONE):
				return tr("The ExternalWallsStaticBody2D node is scaled. Please reset its scale to (1, 1)")

			if not _collision_polygon_node.position.is_zero_approx():
				return tr("The CollisionPolygon2D node is offset from its original position. Please reset its position")
			if not is_zero_approx(_collision_polygon_node.rotation):
				return tr("The CollisionPolygon2D node is rotated. Please reset its rotation to 0")
			if not _collision_polygon_node.scale.is_equal_approx(Vector2.ONE):
				return tr("The CollisionPolygon2D node is scaled. Please reset its scale to (1, 1)")

			return ""
	)


func _build_checks() -> void:
	_add_simple_check(tr("The collision polygon has 10 points"), _test_collision_points_has_enough_points)
	_add_simple_check(tr("There are 4 points aligned with the external wall's inner corners"), _test_collision_points_has_proper_coordinates)


func _test_collision_points_has_enough_points() -> String:
	if _points.size() == 0:
		return tr("The walls polygon has no points! Please make sure you add some points to the polygon")
	elif _points.size() < 10:
		return tr("It seems the polygon has less than 10 points. You can't close those walls with only %s point")%[_points.size()]
	return ''


func _test_collision_points_has_proper_coordinates() -> String:
	var found: Array[bool] = []
	found.resize(_solution_points.size())
	found.fill(false)
	for index in _solution_points.size():
		var solution_point := _solution_points[index]
		for practice_point in _points:
			if solution_point.is_equal_approx(practice_point):
				found[index] = true
	if not found.all(func (param): return param == true):
		return tr("Your points do not seem to be placed at the internal corners of the walls. Did you use snapping?")
	return ''
