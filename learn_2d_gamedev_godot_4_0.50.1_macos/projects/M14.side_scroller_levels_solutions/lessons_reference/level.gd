#ANCHOR:tool_extends
@tool
class_name GameLevel extends Node2D
#END:tool_extends

## The path to the next level's scene file. In this project we use files named
## ".level.tscn" to distinguish level scene files.
@export_file("*.level.tscn") var next_level_path := ""

## Node reference to the gameplay tilemap layer. This is the tilemap that should
## contain the end level flag.
@export var gameplay_tilemap: TileMapLayer = null: set = set_gameplay_tilemap


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	await get_tree().process_frame
	for child in gameplay_tilemap.get_children():
		if child is EndFlag:
			child.body_entered.connect(func (body: Node2D) -> void:
				await get_tree().create_timer(2.0).timeout
				_change_to_next_level()
			)
			break


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if gameplay_tilemap == null:
		warnings.append("Missing gameplay tilemap")
	return warnings


func set_gameplay_tilemap(value: TileMapLayer) -> void:
	gameplay_tilemap = value
	update_configuration_warnings()


func _change_to_next_level() -> void:
	if next_level_path.is_empty():
		get_tree().quit()
		return

	var result := get_tree().change_scene_to_file(next_level_path)
	if result != OK:
		push_error("Failed to load level: " + next_level_path + ". Quitting the game.")
		get_tree().quit()
