extends "res://tours/tileset_tours_base.gd"

func _build() -> void:
	context_set_2d()
	queue_command(func reset_interface_state():
			# Turn off tilemap grid visibility
			interface.tilemap_grid_button.button_pressed = false
			# Turn off highlighting current layer
			interface.tilemap_highlight_button.button_pressed = false
	)

	add_intro_step("Intro to tilesets and tilemaps in Godot!", [
		"[center]In this tour, you get an introduction to tilesets and tilemaps in Godot.[/center]",
		"[center]You'll explore how [b]TileSet[/b] resources work like a painter's palette, and how [b]TileMapLayer[/b] nodes use that palette to paint levels.[/center]",
		"[center]In the next tour, you'll start creating your own tileset from scratch.[/center]",
	])

	bubble_set_title("What are tilemaps?")
	bubble_add_text([
		"Tilemaps are a widely used technique in 2D games to create levels and backgrounds.",
		"Instead of placing individual sprites, tilemaps let you paint your levels using collections of small images called [b]tiles[/b].",
		"In this image, you can see tiles on the left and ivy painted on top of a platform using those tiles on the right:",
	])
	const TERRAIN_EXAMPLE = preload("uid://c7j7ro754ll37")
	bubble_add_texture(TERRAIN_EXAMPLE, 360)
	complete_step()

	bubble_set_title("Why use tilemaps?")
	bubble_add_text([
		"There are several reasons to use tilemaps in your game:",
		"[ul]You can paint your level structure intuitively\n" +
		"You need few art assets\n" +
		"Their performance is great\n" +
		"In Godot, tilemaps are feature-packed: collisions, AI pathfinding, and more are supported out of the box[/ul]",
	])
	complete_step()

	bubble_set_title("Many games use tilemaps")
	bubble_add_text([
		"Games that you know and love use tilemaps for their levels, including [b]Stardew Valley[/b], [b]Dead Cells[/b], or even [b]Hollow Knight[/b]!",
	])
	const STARDEW_VALLEY_SCREENSHOT = preload("uid://8sqr06d588jg")
	bubble_add_texture(STARDEW_VALLEY_SCREENSHOT, 360)
	bubble_add_text([
		"The environment in this screenshot from [b]Stardew Valley[/b] is made up of tiles: the dirt, fences, the grass are all tiles.",
	])
	complete_step()

	scene_open("uid://de1wa1mchwo8")
	bubble_set_title("This is a tilemap")
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.canvas_item_editor])
	scene_deselect_all_nodes()
	bubble_add_text([
		"This little game level I just opened is created entirely using Godot's tilemap system.",
		"Every platform, wall, and decoration you see in the environment is made up of tiles.",
		"Only the player character and the water plane use regular sprites.",
	])
	complete_step()

	bubble_set_title("Run the scene")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.run_bar_play_current_button])
	bubble_add_text([
		"Run the scene to see the tilemap system in action!",
		"Click the [b]Run Current Scene[/b] button in the toolbar.",
		"[b]Controls:[/b]",
		"[ul]" + "[b]Arrow keys[/b]: Move the character around" + "\n" +
		"[b]C[/b]: Jump and double jump" + "[/ul]",
		"Try jumping through the mushroom platforms! They are one-way platforms, so you can jump through them from below without falling through them from above.",
		"Close the game window when you're done exploring."
	])
	bubble_add_task_press_button(interface.run_bar_play_current_button)
	complete_step()

	bubble_set_title("Select the ground layer")
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_scene_nodes_by_path(["MushroomWorld/Ground"])
	bubble_add_text([
		"Now that you've played the level, let's look at a [b]TileMapLayer[/b] node. This node is responsible for drawing tiles in the scene.",
		"Start by selecting the [b]TileMapLayer[/b] node named [b]Ground[/b] in the [b]Scene Dock[/b].",
		"This node contains the main level structure: the floor and walls."
	])
	bubble_add_task_select_nodes_by_path(["MushroomWorld/Ground"])
	complete_step()

	bubble_set_title("The tilemap uses a grid")
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.canvas_item_editor])
	queue_command(func turn_on_grid_and_highlight():
		# Turn on tilemap grid visibility
		interface.tilemap_grid_button.button_pressed = true
		# Turn on highlighting current layer
		interface.tilemap_highlight_button.button_pressed = true
	)
	bubble_add_text([
		"Great! Now let's look at the tilemap grid.",
		"The tilemap is organized into a grid where each square can hold exactly one tile. This ensures all tiles align perfectly.",
		"The grid also makes it easy to paint your level: you just click on a grid square to place a tile there.",
		"For this pixel art game, each grid square is 16x16 pixels to match the tile size."
	])
	complete_step()

	bubble_set_title("Multiple layers work together")
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_scene_nodes_by_path(["MushroomWorld/Ground", "MushroomWorld/Decorations"])
	bubble_add_text([
		"Notice how this level uses multiple [b]TileMapLayer[/b] nodes. I selected two: [b]Ground[/b] and [b]Decorations[/b].",
		"Each node represents one drawing layer and has a different purpose: the [b]Ground[/b] layer contains the main platforms and walls, while [b]Decorations[/b] adds little details like grass and mushrooms.",
		"You can use as many layers as you need to organize your level.",
	])
	complete_step()

	bubble_set_title("The TileSet palette")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"But how does each [b]TileMapLayer[/b] know which tiles it can draw?",
		"It uses a [b]TileSet[/b] resource. Think of it as a painter's palette containing all available tiles.",
		"Just like a painter chooses colors from their palette, the [b]TileMapLayer[/b] lets you pick tiles from its [b]TileSet[/b] to paint the level.",
		"Let's look at the [b]TileSet[/b] that contains all the mushroom world tiles."
	])
	complete_step()

	bubble_set_title("TileMapLayer nodes use the Tileset resource")
	highlight_inspector_properties(["tile_set"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_add_text([
		"Here's how the tilemap system works. You:",
		"1. Create a [b]TileSet[/b] resource (your palette of tiles)",
		"2. Assign the [b]TileSet[/b] to a [b]TileMapLayer[/b] node in the [b]Inspector[/b]",
		"3. Use the [b]TileMapLayer[/b] to paint your level with tiles from the [b]TileSet[/b]",
		"You can see the [b]TileSet[/b] assigned to the [b]Ground[/b] layer in the [b]Inspector[/b]."
	])
	complete_step()

	bubble_set_title("Open the TileSet editor")
	highlight_controls([interface.bottom_tileset_button, interface.tileset])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_add_text([
		"The [b]TileSet[/b] editor is where you create and configure your palette of tiles.",
		"Click the [b]TileSet button[/b] at the bottom to switch from the [b]TileMap editor[/b] to the [b]TileSet editor[/b].",
		"You'll see the actual tiles that make up this mushroom world."
	])

	bubble_add_task_press_button(interface.bottom_tileset_button)
	complete_step()
	bubble_set_title("What's in a TileSet?")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_add_text([
		"A [b]TileSet[/b] resource contains all the data needed to draw tiles:",
		"[ul]Tile textures (the actual images)\n" +
		"Collision shapes for physics\n" +
		"Terrain rules for auto-connecting tiles\n" +
		"Custom properties for each tile[/ul]",
		"The [b]TileSet[/b] editor exposes all of that."
	])
	complete_step()

	bubble_set_title("Your tile palette")
	highlight_controls([interface.tileset])
	bubble_add_text([
		"Here's the [b]TileSet[/b] palette used to create the level you just played!",
		"The interface is busy but you can see individual tiles for the ground on the right side.",
		"Each tile here can be painted onto a [b]TileMapLayer[/b] to build your level.",
		"In the next tours, you'll learn how to create your own [b]TileSet[/b] like this one."
	])
	complete_step()

	bubble_set_title("Excellent!")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"Great work! You now understand how [b]TileSets[/b] and [b]TileMapLayers[/b] work together.",
		"Remember: the [b]TileSet[/b] is your palette of tiles and the [b]TileMapLayer[/b] where you paint with those tiles.",
		"In the next tour, you'll create your first [b]TileSet[/b] from scratch and start building your own levels!"
	])
	complete_step()
