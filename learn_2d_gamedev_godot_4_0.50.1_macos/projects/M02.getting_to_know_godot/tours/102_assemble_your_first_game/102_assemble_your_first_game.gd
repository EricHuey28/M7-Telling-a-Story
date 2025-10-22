extends "res://addons/godot_tours/tour.gd"

const Gobot := preload("res://addons/godot_tours/bubble/gobot/gobot.gd")

const TEXTURE_BUBBLE_BACKGROUND := preload("res://assets/bubble-background.png")
const TEXTURE_GDQUEST_LOGO := preload("res://assets/gdquest-logo.svg")

const CREDITS_FOOTER_GDQUEST := "[center]Godot Interactive Tours · Made by [url=https://www.gdquest.com/][b]GDQuest[/b][/url] · [url=https://github.com/GDQuest][b]Github page[/b][/url][/center]"

const LEVEL_RECT := Rect2(Vector2.ZERO, Vector2(1920, 1080))
const LEVEL_CENTER_AT := Vector2(960, 540)

const TILEMAP_BUTTON_INDEX_TERRAIN_DRAWING_MODE := 0
const TILEMAP_BUTTON_INDEX_PATH_DRAWING_MODE := 1

const TILEMAP_NODE_PATHS: Array[String] = ["Start/Bridges", "Start/InvisibleWalls"]

const ICONS_MAP = {
	node_position_unselected = "res://assets/icon_editor_position_unselected.svg",
	node_position_selected = "res://assets/icon_editor_position_selected.svg",
	script_signal_connected = "res://assets/icon_script_signal_connected.svg",
	script = "res://assets/icon_script.svg",
	script_indent = "res://assets/icon_script_indent.svg",
	zoom_in = "res://assets/icon_zoom_in.svg",
	zoom_out = "res://assets/icon_zoom_out.svg",
	tool_move = "res://assets/icon_move_tool.svg",
}

const SCENE_COMPLETED_PROJECT := "res://completed_project.tscn"
const SCENE_START := "res://start.tscn"
const SCENE_PLAYER := "res://player/player.tscn"
const ROOM_SCENES: Array[String] = [
	"res://levels/rooms/room_a.tscn",
	"res://levels/rooms/room_b.tscn",
	"res://levels/rooms/room_c.tscn",
]
const SCENE_BACKGROUND_SKY := "res://levels/background/background_blue_sky.tscn"
const SCENE_HEALTH_BAR := "res://interface/bars/ui_health_bar.tscn"
const SCENE_CHEST := "res://levels/rooms/chests/chest.tscn"
const SCRIPT_CHEST := "res://levels/rooms/chests/chest.gd"

# TODO: rather than being constant, these should probably scale with editor scale, and probably.
# be calculated relative to the position of some docks etc. in Godot. So that regardless of their
# resolution, people get the windows roughly in the same place.
# We should write a function for that.
#
# Position we set to popup windows relative to the editor's top-left. This helps to keep the popup
# windows outside of the bubble's area.
var popup_window_position := Vector2i(150, 150) * EditorInterface.get_editor_scale()
# We limit the size of popup windows
var popup_window_max_size := Vector2i(860, 720) * EditorInterface.get_editor_scale()


func add_step_open_start_scene_conditionally() -> void:
	var start_scene_root := EditorInterface.get_edited_scene_root()
	if start_scene_root == null or start_scene_root.name != "Start":
		highlight_filesystem_paths([SCENE_START])
		bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
		bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
		bubble_set_title(gtr("Open the start scene"))
		bubble_add_text([
			gtr("Let's start by opening the scene we will be working with."),
			gtr("In the [b]FileSystem Dock[/b] at the bottom-left, find and [b]double-click[/b] on the scene we will be working with: [b]%s[/b].") % SCENE_START.get_file(),
		])
		bubble_add_task(
			gtr("Open the scene [b]%s[/b].") % SCENE_START.get_file(),
			1,
			func task_open_start_scene(_task: Task) -> int:
				var current_scene_root := EditorInterface.get_edited_scene_root()
				if current_scene_root == null:
					return 0
				return 1 if current_scene_root.name == "Start" else 0
		)
		mouse_move_by_callable(
			func get_filesystem_dock_center() -> Vector2: return interface.filesystem_dock.get_global_rect().get_center(),
			get_tree_item_center_by_path.bind(interface.filesystem_tree, SCENE_START),
		)
		mouse_click()
		mouse_click()
		complete_step()
