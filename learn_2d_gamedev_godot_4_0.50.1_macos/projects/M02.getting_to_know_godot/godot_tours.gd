@tool
extends "res://addons/godot_tours/gdtour_metadata.gd"


func _init() -> void:
	open_welcome_menu_automatically = true
	register_tour(
		"101_the_godot_editor",
		"101: The Godot Editor",
		"res://tours/godot-first-tour/godot_first_tour.gd",
		true,
		false
	)
	register_tour(
		"102a_add_player_and_rooms",
		"102.a: Add a Player and Rooms",
		"res://tours/102_assemble_your_first_game/01_add_player_and_rooms/01_add_player_and_rooms.gd",
		false,
		false
	)
	register_tour(
		"102b_add_bridges",
		"102.b: Add bridges",
		"res://tours/102_assemble_your_first_game/02_add_bridges/02_add_bridges.gd",
		false,
		false
	)
	register_tour(
		"102c_add_sky_and_healthbar",
		"102.c: Add a sky and a healthbar",
		"res://tours/102_assemble_your_first_game/03_add_sky_and_healthbar/03_add_sky_and_healthbar.gd",
		false,
		false
	)
	register_tour(
		"102d_connect_healthbar_to_player",
		"102.d: Connect the healthbar to the player health",
		"res://tours/102_assemble_your_first_game/04_connect_healthbar_to_player/04_connect_healthbar_to_player.gd",
		false,
		false
	)
	register_tour(
		"102e_add_chest_spawns_pickups",
		"102.e: Add a chest that spawns pickups",
		"res://tours/102_assemble_your_first_game/05_add_chest_that_spawns_pickups/05_add_chest_that_spawns_pickups.gd",
		false,
		false
	)