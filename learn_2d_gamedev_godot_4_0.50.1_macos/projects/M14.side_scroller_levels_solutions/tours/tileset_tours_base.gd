## This script groups methods and properties that are likely to be used by
## multiple of the tileset tours.
extends "res://addons/godot_tours/tour.gd"

const TEXTURE_BUBBLE_BACKGROUND = preload("res://assets/bubble-background.png")
const TEXTURE_GDQUEST_LOGO = preload("res://assets/gdquest-logo.svg")
const CREDITS_FOOTER_GDQUEST = "Tour created by GDQuest."

## Path to the scene that users edit while following the tours in this series.
const PATH_SCENE_CREATING_TILESETS = "res://creating_tilesets.tscn"


## This creates a complete step with the intro bubble style and background with a large
## title and centered text.
func add_intro_step(title: String, text_lines: Array) -> void:
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size("[center][b]" + title + "[/b][/center]", 32)])

	var formatted_lines: Array[String] = []
	for line in text_lines:
		formatted_lines.append("[center]" + line + "[/center]")
	bubble_add_text(formatted_lines)

	bubble_set_footer(CREDITS_FOOTER_GDQUEST)
	queue_command(func wink_avatar(): bubble.avatar.do_wink())
	complete_step()


func add_step_open_start_scene_conditionally() -> void:
	const ROOT_NODE_NAME = "CreatingTilesets"
	var start_scene_root := EditorInterface.get_edited_scene_root()
	if start_scene_root == null or start_scene_root.name != ROOT_NODE_NAME:
		highlight_filesystem_paths([PATH_SCENE_CREATING_TILESETS])
		bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
		bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
		bubble_set_title(gtr("Open the start scene"))
		bubble_add_text([
			gtr("Let's start by opening the scene we will be working with."),
			gtr("In the [b]FileSystem Dock[/b] at the bottom-left, find and [b]double-click[/b] on the scene we will be working with: [b]%s[/b].") % PATH_SCENE_CREATING_TILESETS.get_file(),
		])
		bubble_add_task(
			gtr("Open the scene [b]%s[/b].") % PATH_SCENE_CREATING_TILESETS.get_file(),
			1,
			func task_open_start_scene(_task: Task) -> int:
				var current_scene_root := EditorInterface.get_edited_scene_root()
				if current_scene_root == null:
					return 0
				return 1 if current_scene_root.name == ROOT_NODE_NAME else 0
		)
		mouse_move_by_callable(
			func get_filesystem_dock_center() -> Vector2: return interface.filesystem_dock.get_global_rect().get_center(),
			get_tree_item_center_by_path.bind(interface.filesystem_tree, PATH_SCENE_CREATING_TILESETS),
		)
		mouse_click()
		mouse_click()
		complete_step()


## Highlights the three vertical dots menu icon in the selected tiles inspector that
## allow you to add a or remove the collision shape to the selected tiles.
func highlight_tiles_inspector_physics_layer_0_vertical_dots() -> void:
	var inspector := interface.tileset_tiles_atlas_editor_select
	var properties := inspector.find_children("", "EditorProperty", true, false)
	for property: EditorProperty in properties:
		# TODO: not sure why some times it's physics_layer_0/polygons_count and others physics_layer_0/polygons
		if property.get_edited_property().begins_with("physics_layer_0/polygons"):
			var control := property.get_child(0)
			var toolbar: HBoxContainer = control.get_child(0)
			var preview: Control = control.get_child(1)
			var dots_menu_button: MenuButton = toolbar.find_children("", "MenuButton", true, false)[-2]
			overlays.highlight_controls([dots_menu_button, preview])
			break
