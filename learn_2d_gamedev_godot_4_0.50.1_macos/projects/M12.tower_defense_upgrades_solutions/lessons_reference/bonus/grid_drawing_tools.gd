@tool
extends Node2D

@export var cell_size := 200.0
@export var grid_size := Vector2i(4, 4)
@export var gap := 20.0


@export_group("Colors")
@export var grid_lines_color := Color("2c426c")
@export var cell_color := Color(0.792, 0.792, 0.792)
@export var highlight_color := Color(0.063, 0.698, 0.937)
@export var link_color := Color("b3b3b3")
@export var special_link_color := Color(1, 0.718, 0.188)


func setup(new_grid_size: Vector2i, new_cell_size: float = 200.0, new_gap: float = 10.0) -> void:
	grid_size = new_grid_size
	cell_size = new_cell_size
	gap = new_gap

	queue_redraw()


func draw_grid_cells(size: Vector2i, color: Color) -> void:
	if is_equal_approx(gap, 0.0):
		draw_rect(Rect2(Vector2.ZERO, size * (cell_size + gap)), color)
		return

	for x in range(size.x):
		for y in range(size.y):
			draw_cell(Vector2i(x, y), color)


func draw_grid_lines(size: Vector2i, color: Color) -> void:
	for x in range(size.x + 1):
		var start_pos := Vector2(x * (cell_size + gap), 0)
		draw_rect(Rect2(start_pos, Vector2(gap, size.y * (cell_size + gap))), color)

	for y in range(size.y + 1):
		var start_pos := Vector2(0, y * (cell_size + gap))
		draw_rect(Rect2(start_pos, Vector2(size.x * (cell_size + gap), gap)), color)


func draw_cell(cell: Vector2i, color: Color) -> void:
	var pos = Vector2(cell) * (cell_size + gap) + Vector2(gap, gap)
	draw_rect(Rect2(pos, Vector2(cell_size, cell_size)), color)


## Draws a line with a circle at each endpoint, representing a connection between two cells.
func draw_link(from: Vector2i, to: Vector2i, color: Color, line_width: float = 6.0, endpoint_radius: float = 10.0) -> void:
	var from_center = Vector2(from) * (cell_size + gap) + Vector2(cell_size / 2 + gap, cell_size / 2 + gap)
	var to_center = Vector2(to) * (cell_size + gap) + Vector2(cell_size / 2 + gap, cell_size / 2 + gap)

	draw_line(from_center, to_center, color, line_width, true)

	draw_circle(from_center, endpoint_radius, color, true,-1.0, true)
	draw_circle(to_center, endpoint_radius, color, true,-1.0, true)


## Draw a highlighted path between multiple cells
func draw_path(path: Array[Vector2i], color: Color, line_width: float = 3.0, endpoint_radius: float = 5.0) -> void:
	for i in range(path.size() - 1):
		draw_link(path[i], path[i + 1], color, line_width, endpoint_radius)


## Get cell position in world coordinates
func get_cell_center(cell: Vector2i) -> Vector2:
	return Vector2(cell) * (cell_size + gap) + Vector2(cell_size / 2 + gap, cell_size / 2 + gap)


## Get cell from world coordinates
func get_cell_from_position(position: Vector2) -> Vector2i:
	var x = int(position.x / (cell_size + gap))
	var y = int(position.y / (cell_size + gap))
	return Vector2i(x, y)


## Check if a cell is within the grid boundaries
func is_valid_cell(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < grid_size.x and cell.y >= 0 and cell.y < grid_size.y
