@tool
extends "res://addons/godot_tours/gdtour_metadata.gd"


func _init() -> void:
	open_welcome_menu_automatically = false
	register_tour(
		"101_overview_animated_sprite_editor",
		"101: Overview of the animated sprite editor",
		"res://tours/101_animated_sprites_overview/101_animated_sprites_overview.gd",
		false,
		false
	)
	register_tour(
		"102_creating_animation",
		"102: Creating an animation",
		"res://tours/102_creating_animation/102_creating_animation.gd",
		false,
		false
	)
	register_tour(
		"103_manipulating_animation_frames",
		"103: Manipulating animation frames",
		"res://tours/103_manipulating_frames/103_manipulating_frames.gd",
		false,
		false
	)
