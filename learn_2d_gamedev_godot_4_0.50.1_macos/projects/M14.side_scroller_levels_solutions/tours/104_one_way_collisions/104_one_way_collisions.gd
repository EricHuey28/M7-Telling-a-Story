extends "res://tours/tileset_tours_base.gd"

const UID_TEXTURE_MUSHROOM = "uid://cdq1w4b0c0y4g"
const TEXTURE_MUSHROOM = preload(UID_TEXTURE_MUSHROOM)

const TILE_ATLAS_COORDS_MUSHROOM_CAPS: Array[Vector2i] = [
	# Blue mushroom cap
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(2, 0),
	Vector2i(3, 0),
	# Orange mushroom cap
	Vector2i(4, 0),
	Vector2i(5, 0),
	Vector2i(6, 0),
	Vector2i(7, 0),
]

const TILE_ATLAS_COORDS_MUSHROOM_STEMS: Array[Vector2i] = [
	# Blue mushroom stem
	Vector2i(1, 1),
	Vector2i(2, 1),
	Vector2i(1, 2),
	Vector2i(2, 2),
	Vector2i(1, 3),
	Vector2i(2, 3),
	# Orange mushroom stem
	Vector2i(5, 1),
	Vector2i(6, 1),
	Vector2i(5, 2),
	Vector2i(6, 2),
	Vector2i(5, 3),
	Vector2i(6, 3),
]

const TILE_ATLAS_COORDS_MUSHROOM_ALL: Array[Vector2i] = TILE_ATLAS_COORDS_MUSHROOM_CAPS + TILE_ATLAS_COORDS_MUSHROOM_STEMS


func get_ground_node() -> TileMapLayer:
	var scene_root := EditorInterface.get_edited_scene_root()
	return scene_root.find_child("Ground") as TileMapLayer


func get_mushroom_source_id() -> int:
	var ground := get_ground_node()
	if ground == null:
		return -1
	for index in ground.tile_set.get_source_count():
		var source_id := ground.tile_set.get_source_id(index)
		var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
		if source != null and source.texture == TEXTURE_MUSHROOM:
			return source_id
	return -1

enum MushroomCaps {
	BLUE,
	ORANGE
}

func is_mushroom_cap_complete(ground: TileMapLayer, cap_type: MushroomCaps) -> bool:
	var start_x := 0 if cap_type == MushroomCaps.BLUE else 4
	var start_coords := Vector2i(start_x, 0)

	var mushroom_source_id := get_mushroom_source_id()
	if mushroom_source_id == -1:
		printerr("Mushroom tile source not found. Cannot check that the mushroom cap was drawn.")
		return false

	var cap_leftmost_cells := ground.get_used_cells_by_id(mushroom_source_id, start_coords)
	for current_cell in cap_leftmost_cells:
		var matched_cells := 0
		# Check if all 4 tiles of mushroom cap are present in sequence
		for i in range(4):
			var cell_to_check := current_cell + Vector2i(i, 0)
			print("Checking cell: ", cell_to_check)
			var tile_data := ground.get_cell_tile_data(cell_to_check)
			print("Tile data for cell ", cell_to_check, ": ", tile_data)
			if tile_data == null:
				print("No tile data found at ", cell_to_check)
				continue
			var atlas_coords := ground.get_cell_atlas_coords(cell_to_check)
			print("Atlas coords for cell ", cell_to_check, ": ", atlas_coords)
			if atlas_coords != Vector2i(start_x + i, 0):
				print("Atlas coords don't match expected ", Vector2i(start_x + i, 0))
				continue
			matched_cells += 1
		if matched_cells == 4:
			print("Mushroom cap complete at cell ", current_cell)
			return true
	return false

func _build() -> void:
	add_intro_step("One-way collisions in tilesets", [
		"In this tour, you practice adding a new tile source with one-way platforms to your tileset.",
		"You'll build upon what you learned in Tour 103 to add mushroom platforms that the character can jump through and stand on.",
	])

	add_step_open_start_scene_conditionally()

	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Adding more tile sources")
	bubble_add_text([
		"In the previous tours, you learned how to add a tile source and set up a physics layer with collision shapes on your tiles. You added collision shapes to every tile.",
		"You can add multiple tile sources to a tileset and add collision shapes and change their properties more selectively.",
		"Let's build upon what you learned and go one step further.",
	])
	complete_step()

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Challenge: add a mushroom tile source")
	bubble_add_text([
		"Your mission, if you accept it, is to add and configure a new tile source to your tile set: mushroom platforms with a cap that the player can jump through.",
		"This time, I will not guide you every step of the way. Instead, you will have to use what you learned in the previous tours to achieve this goal.",
		"To begin the challenge, let's make sure you have the [b]Ground[/b] node selected in the scene tree and open the [b]TileSet editor[/b].",
	])
	highlight_scene_nodes_by_path(["CreatingTilesets/Ground"])
	highlight_controls([interface.tileset, interface.bottom_tileset_button])
	bubble_add_task_select_nodes_by_path(["CreatingTilesets/Ground"])
	bubble_add_task_press_button(interface.bottom_tileset_button)
	complete_step()

	bubble_move_and_anchor(interface.base_control, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("Adding the mushroom tile source")
	bubble_add_text([
		"Your first task is to add the mushroom tile source to your tileset resource and create tiles for every part of the mushrooms.",
		"The editor can create tiles for you automatically by selecting [b]Yes[/b] in the dialog that appears when you add a tile source.",
	])
	highlight_filesystem_paths(["res://assets/tilesets/dark_forest/mushrooms.png"])
	highlight_controls([interface.tileset])
	bubble_add_task("Add the [b]mushroom.png[/b] tile source to the tileset", 1, func(_task: Task) -> int:
		var ground := get_ground_node()
		if ground == null:
			return 0
		for index in ground.tile_set.get_source_count():
			var source_id := ground.tile_set.get_source_id(index)
			var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
			if source == null:
				continue
			if source.texture == TEXTURE_MUSHROOM:
				return 1
		return 0
	)
	bubble_add_task("Create tiles for every part of the mushroom", 1, func(_task: Task) -> int:
		var ground := get_ground_node()
		if ground == null:
			return 0

		for index in ground.tile_set.get_source_count():
			var source_id := ground.tile_set.get_source_id(index)
			var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
			if source == null:
				continue
			if source.texture != TEXTURE_MUSHROOM:
				continue
			for atlas_coords in TILE_ATLAS_COORDS_MUSHROOM_ALL:
				if source.get_tile_at_coords(atlas_coords) == Vector2i(-1, -1):
					return 0
			return 1
		return 0
	)
	complete_step()

	bubble_move_and_anchor(interface.base_control, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("Adding a collision shape to the mushroom cap tiles")
	bubble_add_text([
		"Great job! Now that you have added the mushroom tile source, it's time to add a collision shape to the mushroom cap tiles. The cap tiles are the top row of the mushroom tile source.",
		"Be sure to [b]only add the collision shape to the mushroom cap tiles[/b], not the stem!",
	])
	highlight_controls([interface.tileset])
	bubble_add_task("Turn on the Select tool in the Tileset editor", 1, func(_task: Task) -> int:
		if interface.tileset_tiles_atlas_editor_tools_select_button.button_pressed:
			return 1
		return 0
	)
	bubble_add_task("Add collision shapes to the mushroom cap tiles", 1, func(_task: Task) -> int:
		var ground := get_ground_node()
		if ground == null:
			return 0
		for index in ground.tile_set.get_source_count():
			var source_id := ground.tile_set.get_source_id(index)
			var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
			if source == null:
				continue
			if source.texture != TEXTURE_MUSHROOM:
				continue
			for atlas_coords in TILE_ATLAS_COORDS_MUSHROOM_CAPS:
				var tile_data := source.get_tile_data(atlas_coords, 0)
				if tile_data.get_collision_polygons_count(0) == 0:
					return 0
			for atlas_coords in TILE_ATLAS_COORDS_MUSHROOM_STEMS:
				var tile_data := source.get_tile_data(atlas_coords, 0)
				if tile_data.get_collision_polygons_count(0) > 0:
					return 0
			return 1
		return 0
	)
	complete_step()

	bubble_move_and_anchor(interface.base_control, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("Setting up one-way collisions")
	bubble_add_text([
		"You now have a collision shape on the mushroom cap tiles, but by default it's solid and the player cannot jump through it from below.",
		"To set up one-way collisions, expand the [b]Polygon 0[/b] and turn on the one-way collision property. This will turn selected tiles into one-way platforms.",
	])
	highlight_controls([interface.tileset])
	bubble_add_task("Set up one-way collisions on the mushroom cap tiles", 8, func(_task: Task) -> int:
		var ground := get_ground_node()
		if ground == null:
			return 0
		var completed_tiles := 0
		for index in ground.tile_set.get_source_count():
			var source_id := ground.tile_set.get_source_id(index)
			var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
			if source == null:
				continue
			if source.texture != TEXTURE_MUSHROOM:
				continue
			for atlas_coords in TILE_ATLAS_COORDS_MUSHROOM_CAPS:
				var tile_data := source.get_tile_data(atlas_coords, 0)
				if tile_data.is_collision_polygon_one_way(0, 0):
					completed_tiles += 1
		return completed_tiles
	)
	complete_step()

	bubble_move_and_anchor(interface.base_control, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("Try it out!")
	bubble_add_text([
		"Try painting a mushroom cap tile above a platform in the viewport! Open the [b]TileMap editor[/b] and select the mushroom cap tile.",
		"In the TileMap editor, select the [b]Paint tool[/b] and click and drag over the mushroom tiles to select them all.",
		"Then, [b]Left-Click[/b] in the viewport to stamp the entire mushroom at once.",
		"Right-click in the viewport to erase tiles if you make a mistake.",
	])
	highlight_controls([interface.tilemap, interface.bottom_tilemap_button, interface.canvas_item_editor])
	bubble_add_task_press_button(interface.bottom_tilemap_button)

	bubble_add_task("Paint a mushroom in the level", 1, func(_task: Task) -> int:
		var ground := get_ground_node()
		if ground == null:
			return 0

		for cap in [MushroomCaps.BLUE, MushroomCaps.ORANGE]:
			if is_mushroom_cap_complete(ground, cap):
				return 1
		return 0
	)
	complete_step()

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Run the scene")
	bubble_add_text([
		"Give the scene a try! Press the [b]Play Current Scene[/b] button in the top right corner of the editor.",
		"You should be able to jump through the mushroom cap tiles from below and stand on them. If you misplaced the mushroom cap tiles and platforms, go back to the previous step and try again.",
		"Controls:",
		"[ul]Arrow Keys to move left and right\n" +
		"C to jump[/ul]"
	])
	highlight_controls([interface.run_bar_play_current_button])
	bubble_add_task_press_button(interface.run_bar_play_current_button, "Play Current Scene")
	complete_step()

	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Amazing!")
	bubble_add_text([
		"You now have a second tile source in your tileset with one-way platforms that the player can jump through.",
		"Your progress will be saved if you quit now.",
	])
	complete_step()
