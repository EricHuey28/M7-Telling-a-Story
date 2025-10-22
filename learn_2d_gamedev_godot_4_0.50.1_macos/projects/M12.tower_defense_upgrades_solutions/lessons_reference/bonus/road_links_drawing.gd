extends 'grid_drawing_tools.gd'

@onready var roads: Roads = %Roads
@onready var mob_spawner: MobSpawner = %MobSpawner
@onready var player_hurtbox: Area2D = %PlayerHurtbox


func _draw():
	var pixel_path := roads.find_path_to_target(mob_spawner, player_hurtbox)
	var cell_path: Array[Vector2i] = []
	for pixel in pixel_path:
		cell_path.append(roads.local_to_map(pixel))
	cell_size = 128.0
	gap = 0.0
	draw_path(cell_path, special_link_color, 6.0, 10.0)
