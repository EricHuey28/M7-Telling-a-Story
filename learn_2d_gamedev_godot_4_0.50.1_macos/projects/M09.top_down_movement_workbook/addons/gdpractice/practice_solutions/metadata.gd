@tool
extends "res://addons/gdpractice/metadata.gd"

func _init() -> void:
	list += [
		PracticeMetadata.new(
			"09_top_down_movement_010_asteroid_field",
			"The Asteroid Field",
			preload("L2.P1.asteroid_field/asteroid_field.tscn")
		),
		PracticeMetadata.new(
			"09_top_down_movement_020_bumping_in_walls",
			"Bumping in Walls",
			preload("L4.P1.bumping_in_wall/bumping_in_walls.tscn")
		),
		PracticeMetadata.new(
			"09_top_down_movement_030_smooth_game",
			"Smooth Game",
			preload("L5.P1.smooth_game/smooth_game.tscn")
		),
		PracticeMetadata.new(
			"09_top_down_movement_040_move_to_mouse",
			"Move to Mouse",
			preload("L8.P1.move_to_mouse/move_to_mouse.tscn")
		)
	]
