@tool
extends "res://addons/godot_tours/gdtour_metadata.gd"

func _init() -> void:
	open_welcome_menu_automatically = false

	register_tour(
		"101_overview_of_tileset_and_tilemap_editors",
		"101: Intro to tilesets and tilemaps in Godot",
		"uid://5akcqjef25ps",
		false,
		false
	)

	register_tour(
		"102_your_first_tileset",
		"102: Your first tileset",
		"uid://f4707vv72fkr",
		false,
		false
	)

	register_tour(
		"103_adding_collision_shapes",
		"103: Adding collision shapes",
		"uid://d0h2i5gnngkxo",
		false,
		false
	)

	register_tour(
		"104_one_way_collisions",
		"104: One way collisions",
		"uid://6sow0h7jvthn",
		false,
		false
	)
