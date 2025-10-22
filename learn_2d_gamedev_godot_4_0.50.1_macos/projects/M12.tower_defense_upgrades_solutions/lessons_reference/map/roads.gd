## Script attached to the tilemap layer representing the roads mobs can take in the game.
## It uses the AStar2D class to find paths from the mob spawners to the player base.
class_name Roads extends TileMapLayer

var astar_2d := AStar2D.new()
var road_tiles := get_used_cells()
var map_size := get_used_rect().size


func _ready() -> void:
	_prepare_pathfinding_graph()


## Finds a path from the mob spawner to the target node. Because mob spawners
## and the player base don't move, you only need to call this function once for
## each mob spawner.
func find_path_to_target(mob_spawner_node: Node2D, target_node: Node2D) -> PackedVector2Array:
	var target_position := local_to_map(target_node.global_position)
	var start_position := local_to_map(mob_spawner_node.global_position)

	var start_index := _calculate_index(start_position)
	var end_index := _calculate_index(target_position)

	var cell_coordinates := astar_2d.get_point_path(start_index, end_index)
	var world_coordinates := PackedVector2Array()
	for current_cell in cell_coordinates:
		world_coordinates.append(map_to_local(current_cell))

	return world_coordinates


## Prepares the Astar graph for pathfinding. The algorithm is:
##
## 1. Add all the grid coordinates of the road tiles as points.
## 2. Find and connect adjacent points using a flood-fill algorithm.
##
## We do that because the AStar algorithm doesn't know about the map's
## layout. It needs to know all the positions mobs are allowed to move to and
## from.
func _prepare_pathfinding_graph() -> void:
	# 1. Add the grid coordinates of each road tile.
	#ANCHOR: l2_graph_add_points
	for current_cell: Vector2i in road_tiles:
		var current_cell_index := _calculate_index(current_cell)
		astar_2d.add_point(current_cell_index, current_cell)
		#END: l2_graph_add_points

	# 2. Connect adjacent points.
	#ANCHOR: l2_graph_connect_points_neighbors
	for current_cell: Vector2i in road_tiles:
		for current_neighbor: Vector2i in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
			var neighbor_position := current_cell + current_neighbor
			if get_cell_source_id(neighbor_position) == -1:
				continue
				#END: l2_graph_connect_points_neighbors

			#ANCHOR: l2_graph_connect_points
			var current_cell_index := _calculate_index(current_cell)
			var next_index := _calculate_index(neighbor_position)
			# We need to check for existing connections because for each cell we check all 4 neighbor coordinates
			if not astar_2d.are_points_connected(current_cell_index, next_index):
				astar_2d.connect_points(current_cell_index, next_index)
				#END: l2_graph_connect_points


## Converts a cell's coordinates to a unique index to use in the AStar graph.
func _calculate_index(cell_coordinates: Vector2i) -> int:
	return cell_coordinates.x + (cell_coordinates.y * map_size.x) + 10_000
