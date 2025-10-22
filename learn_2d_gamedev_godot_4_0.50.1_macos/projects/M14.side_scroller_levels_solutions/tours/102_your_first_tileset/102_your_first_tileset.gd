extends "res://tours/tileset_tours_base.gd"

const SCREENSHOT_TERRAIN_CORNERS = preload("uid://cgww4chvrhdn3")
const SCREENSHOT_PLATFORM = preload("uid://bw11g7hg1pkhn")

const PATH_TILE_SOURCE = "res://assets/tilesets/ground_tileset.png"
var FILENAME_TILE_SOURCE = PATH_TILE_SOURCE.get_file()


func _build() -> void:
	# Intro bubble
	add_intro_step(
		"Setting Up Your First Godot Tileset!",
		[
			"In this tour, you'll learn how to create and set up a tileset in Godot.",
			"You'll create a tileset from scratch, add tiles to it, and use your tileset to draw a simple platform.",
			"In the next tour, you'll add collision shapes to your tiles to prevent the player from falling through the platform.",
		]
	)

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("TileMapLayer and TileSet")
	bubble_add_text([
		"To draw tilemap-based levels, you need two components:",
		"[ul]" +  "A [b]TileSet[/b]. It's a resource that you assign to a [b]TileMapLayer[/b] node. It defines your available tiles and their properties." + "\n" +
		"A [b]TileMapLayer[/b] node. This node creates a grid where you can draw tiles to create a level.[/ul]",
		"Think of the [b]TileSet[/b] as a palette of stamps to paint with, and the [b]TileMapLayer[/b] node as your canvas.",
	])
	complete_step()

	bubble_set_title("Opening the starting scene")
	bubble_add_text([
		"Let's get ready to create the tileset. First, open the starting scene I've prepared: [b]creating_tilesets.tscn[/b].",
		"This scene contains a playable character that can move and jump. We'll use this character to test our tileset once it's created."
	])
	bubble_add_task_open_scene("res://creating_tilesets.tscn")
	highlight_filesystem_paths(["res://creating_tilesets.tscn"])
	complete_step()

	bubble_set_title("Creating the TileMapLayer node")
	bubble_add_text([
		"Let's create a [b]TileMapLayer[/b] node first. It allows us to easily create and test the [b]TileSet[/b] resource.",
	])
	bubble_add_task(
		"Create a [b]TileMapLayer[/b] node as a child of the scene root node.",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0
			for child in scene_root.get_children():
				if child is TileMapLayer:
					return 1
			return 0
	)
	bubble_add_task(
		"Rename the new [b]TileMapLayer[/b] node to [b]Ground[/b].",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0
			for child in scene_root.get_children():
				if child is TileMapLayer and child.name == "Ground":
					return 1
			return 0
	)
	highlight_controls([interface.scene_tree, interface.scene_dock_add_button])
	complete_step()

	bubble_set_title("Creating a TileSet resource")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"You now have a [b]TileMapLayer[/b] node in your scene. The next step is to create a [b]TileSet[/b] resource that defines the tiles we can use in this layer.",
		"In the [b]Inspector[/b] dock, click the field next to the [b]Tile Set[/b] property and select [b]New TileSet[/b].",
		"This creates an empty [b]TileSet[/b] resource that we'll configure in the next steps."
	])
	bubble_add_task(
		"Assign a [b]TileSet[/b] resource to the [b]Tile Set[/b] property.",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			var nodes := scene_root.find_children("*", "TileMapLayer")
			if nodes.is_empty():
				return 0
			var tile_map_layer := nodes.front() as TileMapLayer
			return 1 if tile_map_layer.tile_set != null else 0
			return 0
	)
	scene_select_nodes_by_path(["CreatingTilesets/Ground"])
	highlight_inspector_properties(["tile_set"])
	complete_step()

	bubble_set_title("Setting the tile size")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"The engine needs to know the size of individual tiles in the tileset to draw them correctly.",
		"The [b]TileSet[/b] resource's [b]Tile Size[/b] property controls the size of each tile in pixels. Its value should match the size of your tile art assets.",
		"Our artist drew tiles that are 16x16 pixels. Luckily for us, that's the default value when you create a [b]TileSet[/b] resource! We can use the default value."
	])
	expand_inspector_resource("tile_set")
	highlight_inspector_properties(["tile_size"])
	complete_step()

	bubble_set_title("Opening the TileSet editor")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"When selecting a [b]TileMapLayer[/b] node, the editor reveals the [b]TileMap editor[/b]. This bottom panel allows you to draw tiles in the level.",
		"We don't have any tiles yet, so we cannot draw anything! Open the [b]TileSet editor[/b] so we can start adding tiles to the TileSet.",
	])
	highlight_controls([interface.bottom_tileset_button])
	highlight_controls([interface.tileset, interface.tilemap])
	bubble_add_task_press_button(interface.bottom_tileset_button)
	complete_step()

	bubble_set_title("The TileSet editor")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"The [b]TileSet editor[/b] is where we define our tiles and their properties.",
		"The [b]Tile Sources[/b] tab on the left lists textures containing multiple tiles that you add to the tileset.",
		"The empty area on the right allows you to select and change the properties of individual tiles in a tile source.",
	])
	highlight_controls([interface.tileset])
	complete_step()

	bubble_set_title("Tile sources")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"We call the texture containing tiles a [b]Tile Source[/b]. It's a single image containing multiple tiles arranged in a grid.",
		"To define what tiles are available in the tileset, you add a tile source, and then you define which parts of the images should be usable as tiles.",
		"Our artist prepared tile sources for you to use in this module. We'll use this one to create our first tileset:",
	])
	bubble_add_texture(SCREENSHOT_TERRAIN_CORNERS, 480)
	highlight_controls([interface.tileset])
	complete_step()

	bubble_set_title("Understanding tile creation options")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"There are two ways to create tiles from a source:",
		"[ul][b]Automatically:[/b] Godot creates tiles for all non-transparent regions in the source for you. When you select [b]Yes[/b] in the popup, Godot uses this method." + "\n" +
		"[b]Manually:[/b] You select and create individual tiles yourself.[/ul]",
		"For now we will do this manually (note: A popup will appear in the next step to give you this choice. Remember to select \"No\").",
	])
	complete_step()

	bubble_set_title("Adding the tile source")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's add our first tile source. In the [b]FileSystem[/b] dock, locate the image [b]%s[/b]. This image contains all the ground tiles we'll use in our level." % [FILENAME_TILE_SOURCE],
		"Drag and drop it onto the tile source area in the TileSet editor.",
		"[b]Important:[/b] Remember to select [b]No[/b] in the popup that'll appear so we can create tiles manually.",
	])
	highlight_filesystem_paths([PATH_TILE_SOURCE])
	highlight_controls([interface.tileset_tiles_panel])
	bubble_add_task(
		"Add the [b]%s[/b] file to the [b]TileSet[/b] resource." % [FILENAME_TILE_SOURCE],
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			for child in scene_root.get_children():
				if child is TileMapLayer and child.tile_set != null:
					if child.tile_set.get_source_count() > 0:
						return 1
			return 0
	)
	mouse_click_drag_by_callable(
		func() -> Vector2: return get_tree_item_center_by_path(interface.filesystem_tree, PATH_TILE_SOURCE),
		func() -> Vector2: return get_control_global_center(interface.tileset_tiles)
	)
	complete_step()

	bubble_set_title("Naming the source")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's give our source a descriptive name to keep things organized. By default, the name is set to the file name, but we can change it to something simpler.",
		"In the middle column of the TileSet editor, set the [b]Name[/b] property to [b]Ground[/b]."
	])
	highlight_controls([interface.tileset_tiles_atlas_editor_setup])
	bubble_add_task(
		"Rename the tile source to [b]Ground[/b].",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			for child in scene_root.get_children():
				if child is TileMapLayer and child.tile_set != null:
					if child.tile_set.get_source_count() > 0:
						var source_id = child.tile_set.get_source_id(0)
						var atlas = child.tile_set.get_source(source_id)
						if atlas.resource_name == "Ground":
							return 1
			return 0
	)
	complete_step()

	bubble_set_title("Creating your first tile manually")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Now that we have our source, let's create our first tile manually:",
		"[ul]" + "Make sure the %s [b]Setup[/b] tool is active in the TileSet editor toolbar" % [bbcode_generate_icon_image_by_name("Tools")] + "\n" +
		"Click on a tile in the source image on the right (choose one of the ground tiles with grass on top)" + "[/ul]",
		"You'll see a highlighted border around the selected tile, which means it's now available to draw.",
	])
	highlight_controls([interface.tileset_tiles_atlas_editor_tools_setup_button])
	highlight_controls([interface.tileset_tiles_atlas_editor_atlas_view])
	bubble_add_task(
		"Create at least one tile by clicking on a tile in the tile source.",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			for child in scene_root.get_children():
				if child is TileMapLayer and child.tile_set != null:
					if child.tile_set.get_source_count() > 0:
						var source_id: int = child.tile_set.get_source_id(0)
						var atlas: TileSetAtlasSource = child.tile_set.get_source(source_id)
						if atlas.get_tiles_count() > 0:
							return 1
			return 0
	)
	complete_step()

	bubble_set_title("Opening the TileMap editor")
	bubble_move_and_anchor(interface.tileset, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"That's it! You've created your first tile.",
		"Let's switch to the [b]TileMap[/b] editor to start drawing with our tile.",
	])
	highlight_controls([interface.bottom_tilemap_button])
	bubble_add_task_press_button(interface.bottom_tilemap_button)
	complete_step()

	bubble_set_title("Drawing your first tile")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's draw with our manually created tile. For that, you need to select the %s [b]Paint Tool[/b] in the TileMap editor toolbar:" % [bbcode_generate_icon_image_by_name("Edit")],
		"1. Make sure the %s [b]Paint Tool[/b] is selected" % [bbcode_generate_icon_image_by_name("Edit")],
		"2. Look at the tile palette on the right side of the editor. You should see your tile there",
		"3. Click on this tile in the palette to select it"
	])
	highlight_controls([interface.tilemap_tiles_toolbar_paint_button, interface.tilemap_tiles_atlas_view])
	context_set_2d()
	bubble_add_task_toggle_button(interface.tilemap_tiles_toolbar_paint_button, true, "Paint Tool")
	complete_step()

	bubble_set_title("Placing the tile")
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"With the %s paint tool and tile selected, you can now place it on the grid." % [bbcode_generate_icon_image_by_name("Edit")],
		"Click in the 2D viewport to draw the tile. Place a tile right below the player character, so they can stand on it.",
		"If you're having trouble drawing:",
		"[ul]Make sure the %s [b]Select Mode[/b] is active in the viewport toolbar as other modes won't let you draw" % [bbcode_generate_icon_image_by_name("ToolSelect")] + "\n" +
		"Check that your tile is selected in the palette (it should have a highlighted border)[/ul]"
	])
	highlight_controls([interface.canvas_item_editor_toolbar_select_button, interface.canvas_item_editor_viewport, interface.tilemap_tiles_atlas_view])
	bubble_add_task_toggle_button(interface.canvas_item_editor_toolbar_select_button, true, "Select Mode")
	bubble_add_task(
		"Place a ground tile below the player character.",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			var player = scene_root.find_child("Player")
			if player == null:
				return 0

			for child in scene_root.get_children():
				if child is not TileMapLayer:
					continue

				var used_cells: Array[Vector2i] = child.get_used_cells()
				for cell: Vector2i in used_cells:
					var tile_position_local: Vector2 = child.map_to_local(cell)
					var tile_position_global = child.to_global(tile_position_local)

					# Check if tile is below player (higher Y position) and roughly aligned horizontally
					if tile_position_global.y > player.global_position.y and abs(tile_position_global.x - player.global_position.x) < 16:
						return 1
			return 0
	)
	complete_step()

	bubble_set_title("Populating tiles automatically")
	bubble_move_and_anchor(interface.tilemap, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Instead of enabling tiles in a tile source manually, we can populate them all automatically.",
		"Let's return to the [b]TileSet editor[/b] and do that next.",
	])
	highlight_controls([interface.bottom_tileset_button, interface.tileset])
	bubble_add_task_press_button(interface.bottom_tileset_button)
	complete_step()

	bubble_set_title("Using the auto-creation tool")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"You can use the auto-creation tool to add all remaining tiles from the tile source at any time:",
		"[ul]" + "In the TileSet editor, click the [b]Three Dots[/b] button on the right of the tileset toolbar" + "\n" +
		"Select [b]Create Tiles in Non-Transparent Texture Regions[/b]" + "[/ul]",
		"All tiles from the tile source will be automatically detected and created!",
	])
	highlight_controls([interface.tileset_tiles_atlas_editor_setup_toolbar_menu_button, interface.tileset_tiles_atlas_editor_atlas_view])
	complete_step()

	bubble_set_title("Returning to the TileMap editor")
	bubble_move_and_anchor(interface.tileset, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Now that we have all our tiles available, let's return to the TileMap editor and draw a few more tiles.",
		"Click the [b]TileMap button[/b] at the bottom of the editor."
	])
	highlight_controls([interface.bottom_tilemap_button])
	bubble_add_task_press_button(interface.bottom_tilemap_button)
	complete_step()

	bubble_set_title("Creating platforms")
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"You now have all the tiles needed to create a platform for our character to stand on.",
		"In the tile palette on the right, select individual tiles and try to draw a small complete platform in the viewport using the %s [b]Paint Tool[/b]." % [bbcode_generate_icon_image_by_name("Edit")],
		"[b]Left Click[/b] to paint tiles in the viewport and [b]Right Click[/b] to erase them.",
		"Take as little or as much time as you'd like to create a platform. This is a moment for you to experiment with the tiles and see how they fit together.",
	])
	highlight_controls([interface.tilemap_tiles_toolbar_paint_button, interface.canvas_item_editor_viewport, interface.tilemap_tiles_atlas_view])
	complete_step()

	const PATH_TILESET_RESOURCE = "new_tile_set.tres"
	bubble_set_title("Saving the TileSet")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's save our [b]TileSet[/b] as a resource file so you can reuse it later:",
		"1. In the [b]Inspector[/b], right-click the [b]Tile Set[/b] property",
		"2. Select [b]Save As...[/b] and save it to [b]%s[/b] (Godot will suggest this name by default)" % [PATH_TILESET_RESOURCE],
		"Saving your [b]TileSet[/b] as a separate resource means you can reuse it across multiple [b]TileMapLayer[/b] nodes and game levels without duplicating work."
	])
	highlight_inspector_properties(["tile_set"])
	bubble_add_task(
		"Save the TileSet resource as [b]%s[/b]" % [PATH_TILESET_RESOURCE.get_file()],
		1,
		func(_task: Task) -> int:
			if FileAccess.file_exists(PATH_TILESET_RESOURCE):
				return 1
			return 0
	)
	complete_step()

	bubble_set_title("Testing the scene")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's run the scene to test our tilemap with the character. Click the [b]Run Current Scene[/b] button to start the game.",
		"You'll notice the character falls right through our tiles. This happens because we haven't added collision shapes to our tileset yet!",
		"The character doesn't \"see\" the tiles as physical objects. We have to add collision shapes to the tiles so the player can stand on them. That's what we'll do in the next tour."
	])
	highlight_controls([interface.run_bar_play_current_button])
	complete_step()

	bubble_set_title("Mission accomplished!")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"You now know how to create a basic tileset in Godot!",
		"Your progress will be saved if you quit now.",
		"In the next tour, we'll add collision shapes to our tiles so the character can stand on them."
	])
	complete_step()
