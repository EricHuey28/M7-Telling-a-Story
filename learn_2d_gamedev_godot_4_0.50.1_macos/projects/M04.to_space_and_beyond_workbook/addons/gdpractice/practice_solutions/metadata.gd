@tool
extends "res://addons/gdpractice/metadata.gd"


func _init() -> void:
	list += [
		PracticeMetadata.new(
			"04_to_space_and_beyond_010_the_bullet",
			"The bullet",
			preload("res://addons/gdpractice/practice_solutions/L2.P1.bullet/bullet.tscn")
		),
		PracticeMetadata.new(
			"04_to_space_and_beyond_020_character_input",
			"My character is not moving!",
			preload("res://addons/gdpractice/practice_solutions/L3.P1.character_input/character_input.tscn")
		),
		PracticeMetadata.new(
			"04_to_space_and_beyond_030_character_diagionals",
			"Speeding in diagonals",
			preload("res://addons/gdpractice/practice_solutions/L3.P2.character_diagonals/character_diagonals.tscn")
		),
		PracticeMetadata.new(
			"04_to_space_and_beyond_040_boosting_circle",
			"Make the circle boost!",
			preload("res://addons/gdpractice/practice_solutions/L4.P1.boosting_circle/boosting_circle.tscn")
		),
		PracticeMetadata.new(
			"04_to_space_and_beyond_050_steering_copy",
			"Steering the circle",
			preload("res://addons/gdpractice/practice_solutions/L5.P1.steering/steering.tscn")
		),
	]
