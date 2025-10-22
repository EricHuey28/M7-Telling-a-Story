# This script sets up pathfinding for mobs to follow roads using AStarGrid2D.
# Unlike the regular AStar2D, you don't need to manually connecting each point
# so it's a bit simpler to use.
extends TileMapLayer

var astar_grid_2d := AStarGrid2D.new()
var road_tiles := get_used_cells()
var map_size := get_used_rect().size


func _ready() -> void:
	_prepare_pathfinding_graph()


func find_path_to_target(mob_spawner_node: Node2D, target_node: Node2D) -> PackedVector2Array:
	var start_position := local_to_map(to_local(mob_spawner_node.global_position))
	var target_position := local_to_map(to_local(target_node.global_position))

	# You can use the get_id_path() method to find a path between two points
	# This returns an array of Vector2i coordinates representing grid cells
	var cell_coordinates := astar_grid_2d.get_id_path(start_position, target_position)

	# The positions are in grid coordinates, so we still need to convert them to world coordinates
	var world_coordinates := PackedVector2Array()
	for current_cell in cell_coordinates:
		world_coordinates.append(map_to_local(current_cell))
	return world_coordinates


func _prepare_pathfinding_graph() -> void:
	# First we set up the grid boundaries for pathfinding. The region defines
	# which part of our game grid/tilemap AStarGrid2D should consider.
	astar_grid_2d.region = Rect2i(_find_top_left_road_cell(), map_size)

	# You can optionally tell AStarGrid2D the size of each cell in the grid. It
	# can then directly return local coordinates when calling
	# AstarGrid2D.get_point_path().
	astar_grid_2d.cell_size = Vector2.ONE * 64

	# Disable diagonal movement to indicate that mobs can only move up, down,
	# left, and right.
	astar_grid_2d.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	# Always call update() after changing AStarGrid2D properties!
	# This applies all your settings and prepares the grid for pathfinding.
	astar_grid_2d.update()

	# Now we need to tell AStarGrid2D which cells are walkable (roads) and which are obstacles
	# We loop through every cell in our pathfinding region for that. Otherwise
	# by default all cells are considered walkable.
	for current_x in range(astar_grid_2d.region.position.x, astar_grid_2d.region.end.x):
		for current_y in range(astar_grid_2d.region.position.y, astar_grid_2d.region.end.y):
			var current_cell := Vector2i(current_x, current_y)
			# If there's no tile at this position (source_id is -1), it's an obstacle
			# set_point_solid() marks this cell as impassable for pathfinding
			if get_cell_source_id(current_cell) == -1:
				astar_grid_2d.set_point_solid(current_cell)


func _find_top_left_road_cell() -> Vector2i:
	var top_left: Vector2i = Vector2i.ONE * 10_000
	for cell in road_tiles:
		if cell.x < top_left.x:
			top_left.x = cell.x
		if cell.y < top_left.y:
			top_left.y = cell.y
	return top_left
