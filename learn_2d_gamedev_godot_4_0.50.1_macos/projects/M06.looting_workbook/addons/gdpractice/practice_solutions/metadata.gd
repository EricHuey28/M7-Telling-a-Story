@tool
extends "res://addons/gdpractice/metadata.gd"


func _init() -> void:
	list += [
		PracticeMetadata.new(
			"06_looting_010_hover_the_balloon",
			"Hover the balloon",
			preload("res://addons/gdpractice/practice_solutions/L3.P1.hover_the_balloon/hover_the_balloon.tscn")
		),
		PracticeMetadata.new(
			"06_looting_020_sting_the_balloon",
			"Sting the balloon",
			preload("res://addons/gdpractice/practice_solutions/L3.P2.sting_the_balloon/sting_the_balloon.tscn")
		),
		PracticeMetadata.new(
			"06_looting_030_open_the_door",
			"Open the door",
			preload("res://addons/gdpractice/practice_solutions/L5.P1.open_the_door/open_the_door.tscn")
		),
		PracticeMetadata.new(
			"06_looting_040_pop_the_balloon",
			"Pop the balloon",
			preload("res://addons/gdpractice/practice_solutions/L5.P2.pop_the_balloon/pop_the_balloon.tscn")
		),
		PracticeMetadata.new(
			"06_looting_050_the_piñata",
			"The pinata",
			preload("res://addons/gdpractice/practice_solutions/L6.P1.the_pinata/the_pinata.tscn")
		),
	]
