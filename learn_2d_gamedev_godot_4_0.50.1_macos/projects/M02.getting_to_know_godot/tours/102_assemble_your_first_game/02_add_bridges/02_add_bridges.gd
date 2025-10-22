extends "../102_assemble_your_first_game.gd"


func _build() -> void:
	# Set editor state according to the tour's needs.
	queue_command(func reset_editor_state_for_tour():
		interface.canvas_item_editor_toolbar_grid_button.button_pressed = false
		interface.canvas_item_editor_toolbar_smart_snap_button.button_pressed = false
		interface.bottom_output_button.button_pressed = false
	)

	part_010_adding_bridges()


func part_010_adding_bridges() -> void:

	add_step_open_start_scene_conditionally()

	# 0100: drawing bridges - selecting tilemap node
	highlight_controls([interface.canvas_item_editor])
	highlight_scene_nodes_by_path(["Start/Bridges"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Add Bridges"))
	bubble_add_text([
		gtr("Let's draw bridges to connect the rooms using a [b]TileMap[/b] next."),
	])
	bubble_add_task_select_nodes_by_path(["Start/Bridges"])
	complete_step()

	# 0101: drawing bridges - bottom panel tabs
	highlight_controls([interface.bottom_tileset_button, interface.bottom_tilemap_button, interface.tilemap], true)
	queue_command(func tilemap_ensure_open():
		interface.bottom_tilemap_button.button_pressed = true
	)
	bubble_set_title(gtr("Tilesets and Tilemaps"))
	highlight_scene_nodes_by_path(["Start/Bridges"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		gtr("As soon as you selected [b]Bridges[/b], a bottom panel expanded and two tabs appeared: [b]TileSet[/b] and [b]TileMap[/b]."),
		gtr("It's because [b]Bridges[/b] is a [b]TileMapLayer[/b] node."),
		gtr("Godot will automatically show you the relevant tabs for the selected node."),
		gtr("That's why we say the [b]Bottom Panels[/b] are \"[b]contextual[/b]\". They appear in the right context."),
	])
	complete_step()

	queue_command(func tilemap_ensure_open():
		interface.bottom_tilemap_button.button_pressed = true)
	highlight_controls([interface.tilemap, interface.bottom_tilemap_button])
	bubble_set_title(gtr("The TileMap Tab"))
	bubble_add_text([
		gtr("For drawing bridges, we will use the [b]TileMap[/b] tab."),
		gtr("Tilemaps are an efficient way to draw game levels using a grid and [b]tiling images[/b]."),
		gtr("Most of your childhood 2D games used tilemaps (like Final Fantasy 6 and Zelda: Link's Awakening)!"),
	])
	complete_step()

	highlight_controls([interface.tilemap, interface.bottom_tilemap_button])
	bubble_set_title(gtr("Tile Selection"))
	bubble_add_text([
		gtr("To the right of the panel, you can see the different tile images we have at our disposal."),
		gtr("You can select them one at a time and draw on the map, but there is a faster way: using [b]Terrains[/b]."),
	])
	complete_step()

	highlight_controls([interface.tilemap_tabs])
	bubble_set_title(gtr("The Terrains Tab"))
	bubble_add_text([
		gtr("Terrains are a set of rules to create compositions for auto-tiling. They help us draw faster."),
		gtr("You'll learn more about creating terrains later in the course."),
		gtr("Click on the [b]Terrains[/b] tab to find the terrain we've set up for the bridges."),
	])
	bubble_add_task_set_tilemap_tab_by_control(interface.tilemap_terrains_panel)
	complete_step()

	# 0102: select bridges tree item
	highlight_controls([interface.tilemap_terrains_tree])
	bubble_set_title(gtr("The Bridge Terrain"))
	bubble_add_text([
		gtr("Next, click the terrain named [b]Bridge[/b] in the tree on the left to select it."),
	])
	mouse_move_by_callable(
		func get_tilemap_center() -> Vector2:
			return interface.tilemap.get_global_rect().get_center(),
		func get_terrain_bridges_center() -> Vector2:
			var terrain_bridges: TreeItem = interface.tilemap_terrains_tree.get_root().get_child(0).get_child(0)
			var center: Vector2 = interface.tilemap_terrains_tree.get_item_area_rect(terrain_bridges).get_center()
			center += interface.tilemap_terrains_tree.global_position
			return center
	)
	mouse_click()
	bubble_add_task(
		gtr("Select the [b]Bridge[/b] terrain."),
		1,
		func(_task: Task) -> int:
			var terrain_bridges: TreeItem = interface.tilemap_terrains_tree.get_root().get_child(0).get_child(0)
			var selected: TreeItem = interface.tilemap_terrains_tree.get_selected()
			return 1 if selected == terrain_bridges else 0,
	)
	complete_step()

	bubble_set_title(gtr("The Path Drawing Mode"))
	highlight_tilemap_list_item(interface.tilemap_terrains_tiles, TILEMAP_BUTTON_INDEX_PATH_DRAWING_MODE)
	bubble_add_text([
		gtr("Now, click on the Path-like icon to select the [b]Path Drawing Mode[/b]."),
		gtr("With this tool active, you can draw your bridges."),
	])
	mouse_move_by_callable(
		func get_terrain_bridges_center() -> Vector2:
			var terrain_bridges: TreeItem = interface.tilemap_terrains_tree.get_root().get_child(0).get_child(0)
			var center: Vector2 = interface.tilemap_terrains_tree.get_item_area_rect(terrain_bridges).get_center()
			center += interface.tilemap_terrains_tree.global_position
			return center,
		func get_tool_center() -> Vector2:
			var rect := interface.tilemap_terrains_tiles.get_item_rect(TILEMAP_BUTTON_INDEX_PATH_DRAWING_MODE)
			return rect.get_center() + interface.tilemap_terrains_tiles.global_position,
	)
	bubble_add_task(
		gtr("Select the [b]Path Drawing Mode[/b]."),
		1,
		func(_task: Task) -> int:
			return 1 if interface.tilemap_terrains_tiles.is_selected(TILEMAP_BUTTON_INDEX_PATH_DRAWING_MODE) else 0,
	)
	mouse_click()
	complete_step()

	bubble_set_title(gtr("Restore the Select mode"))
	highlight_controls([interface.canvas_item_editor_toolbar_select_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		gtr("As we are currently in the [b]Move Mode[/b], we cannot draw the bridges. To draw, we need to be in the [b]Select Mode[/b]."),
		gtr("Click the [b]Select Mode[/b] button to activate it."),
	])
	bubble_add_task_press_button(interface.canvas_item_editor_toolbar_select_button, gtr("Select Mode"))
	complete_step()

	#TODO: low priority: highlight paths between rooms?
	bubble_set_title(gtr("Draw The Bridges"))
	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_add_text([
		gtr("[b]Left Click and drag[/b] on the map to draw bridges between rooms.", "[b]Right-click[/b] to erase bridges."),
		gtr("Try to connect the openings in the rooms. The openings are located where there are gaps in the red crosses around the perimeter of the room."),
		gtr("You are free to draw the bridges however you like.")
	])
	complete_step()

	bubble_set_title(gtr("Reconnecting bridges"))
	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_add_text([
		gtr("If you lift the mouse button when drawing bridges, you may see gaps like this:"),
	])
	bubble_add_texture(load("res://assets/screenshot_bridges_disconnected.png"))
	bubble_add_text([
		gtr("To correct that and get clean corners, click and drag over the already drawn tiles."),
		gtr("This allows the tilemap's terrain to apply its rules and clean up the bridge for you. That's the power of terrains!")
	])
	complete_step()

	highlight_controls([interface.canvas_item_editor, interface.run_bar_play_current_button])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Excellent! Time to play!"))
	bubble_add_text([
		gtr("Let's see if everything works as expected."),
		gtr("The [b]Play[/b] button we used earlier is for running the [b]%s[/b] scene.") %
		SCENE_COMPLETED_PROJECT.get_file(),
		gtr("To play the [b]current[/b] scene, click the [b]Play Edited Scene[/b] button to run the scene."),
		gtr("Alternatively, you can press press [b]%s[/b] on your keyboard.") % shortcuts.run_current,
		gtr("Then, press [b]%s[/b] or close the game window to stop the game.") % shortcuts.stop,
		]
	)
	bubble_add_task_press_button(interface.run_bar_play_current_button, gtr("Play Edited Scene"))
	complete_step()

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("The missing \"walls\""))
	bubble_add_text([
		gtr("While playing, did you notice something strange? The player can move outside of the bridges!"),
		gtr("This is because the bridges lack [b]collision shapes[/b]. They are invisible geometric shapes that control where characters can move."),
		gtr("What you see on screen and the physical limits of the world are two separate layers."),
		gtr("Our bridges currently lack this invisible layer. We'll add it next."),
	])
	complete_step()


	highlight_scene_nodes_by_path(["Start/InvisibleWalls"], -1, true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Select the InvisibleWalls node"))
	bubble_add_text([
		gtr("Did you notice the red crosses around the rooms? They are collision shapes we pre-added to the rooms to give them \"walls\", or limits."),
		gtr("We can draw them using the [b]InvisibleWalls[/b] tilemap."),
		gtr("Let's add \"walls\" to prevent players from walking outside of the bridges."),
	])
	bubble_add_task_select_nodes_by_path(["Start/InvisibleWalls"])
	complete_step()

	#TODO: check, when recording in video, the tilemap bottom panel tab automatically changed to terrains?
	queue_command(func open_tilemap_bottom_panel():
		interface.bottom_tilemap_button.button_pressed = true
	)
	highlight_controls([interface.tilemap_tabs, interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Select the Tiles tab"))
	bubble_add_text([
		gtr("In the [b]TileMap[/b] bottom panel, we need to find and select the red cross."),
		gtr("Since we were previously looking at the [b]Terrains[/b] tab, we need to switch back to the [b]Tiles[/b] tab first, where the red cross is."),
	])
	bubble_add_task_set_tilemap_tab_by_control(interface.tilemap_tiles_panel)
	complete_step()

	highlight_controls([interface.tilemap, interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Draw the invisible walls"))
	bubble_add_text([
		gtr("Select the big [b]red cross[/b] in the [b]TileMap[/b] bottom panel."),
		gtr("Then, [b]Left Click and drag[/b] around bridges in the viewport to draw red cross tiles. They will prevent the player from moving off the bridges."),
		gtr("If you make a mistake, you can use the [b]Right Click[/b] to remove tiles."),
		gtr("Take your time and draw the invisible walls around all bridges. Once you're done, click the [b]Next[/b] button"),
	])
	complete_step()

	bubble_set_title(gtr("Let's try this!"))
	highlight_controls([interface.run_bar_play_current_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		gtr("If you run the scene, you should see the player can't walk anywhere you drew a red cross."),
		gtr("Click the [b]Play Edited Scene[/b] button in the top-right or press [b]%s[/b] to run the scene.") % shortcuts.run_current,
		gtr("Press [b]%s[/b] to close the game window once you're done.") % shortcuts.stop,
	])
	bubble_add_task_press_button(interface.run_bar_play_current_button, gtr("Play Edited Scene"))
	complete_step()

	bubble_set_title(gtr("Excellent!"))
	bubble_add_text([
		gtr("You learned to use tilemaps to draw bridges and add collision shapes that prevent the player from walking outside of the bridges."),
		gtr("In the next part, you'll make the level feel fuller by adding a sky and a health bar."),
	])
	complete_step()
