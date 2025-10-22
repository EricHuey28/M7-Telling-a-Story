extends "res://addons/godot_tours/tour.gd"

const TEXTURE_BUBBLE_BACKGROUND = preload("res://assets/bubble-background.png")
const TEXTURE_GDQUEST_LOGO = preload("res://assets/gdquest-logo.svg")
const CREDITS_FOOTER_GDQUEST = "Tour created by GDQuest."

func _build() -> void:
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size("[center][b]Setting Up Terrain Auto-Tiling![/b][/center]", 32)])
	bubble_add_text([
		"[center]In this tour, you learn how to set up terrain auto-tiling for your tileset.[/center]",
		"[center]You'll create terrain sets and configure peering bits to automatically select the right tile variants based on neighboring tiles.[/center]",
		"[center]In the next tour, you'll switch focus to tilemaps and learn the tools at your disposal to draw and edit levels.[/center]",
	])
	bubble_set_footer(CREDITS_FOOTER_GDQUEST)
	queue_command(func wink_avatar(): bubble.avatar.do_wink())
	complete_step()

	bubble_set_title("Understanding terrain modes")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_add_text([
		"Before we dive into the setup, let's run through the different [b]modes[/b] available for terrain auto-tiling.",
		"The terrain system has three modes: [b]Match Sides[/b], [b]Match Corners[/b], [b]Match Corners and Sides[/b].",
		"In short, the modes offer tradeoffs between drawing freedom and the number of tiles you need to set up.",
		"I'll show you what each mode does over the next steps."
	])
	complete_step()

	bubble_set_title("The Match Sides mode")
	scene_open("res://tours/tilesets/match_sides.tscn")
	highlight_controls([interface.canvas_item_editor_viewport])
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_add_text([
		"Let's start with the simplest mode: [b]Match Sides[/b]. I opened a scene with a tilemap drawn using this mode. You can see it in the viewport.",
		"The Match Sides mode allows you to draw horizontal and vertical lines of tiles, fill rectangular areas, and... that's it!",
		"It uses the 16 tiles you can see in the image below:",
	])
	# TODO: replace
	# bubble_add_texture(load("res://assets/guides/match_sides.png"))
	bubble_add_text([
		"It's the easiest mode to set up, but it has big limitations: it doesn't allow you to create inner corners, hanging ledges, or any other more organic shapes."
	])
	complete_step()

	bubble_set_title("The Match Corners mode")
	scene_open("res://tours/tilesets/match_corners.tscn")
	highlight_controls([interface.canvas_item_editor_viewport])
	bubble_add_text([
		"I just opened a scene with a tilemap drawn using the [b]Match Corners[/b] mode.",
		"This mode allows you to create inner corners and ledges on top of filling rectangular areas.",
		"It also only uses 16 tiles, but it can create a lot more shapes than the [b]Match Sides[/b] mode. The art assets are a little harder to draw, but the results are worth it.",
		"If you're making a Metroidvania game where you only need to create a few different shapes, this mode is a good choice."
	])
	complete_step()

	bubble_set_title("The Match Corners and Sides mode")
	scene_open("res://tours/tilesets/match_corners_and_sides.tscn")
	highlight_controls([interface.canvas_item_editor_viewport])
	bubble_add_text([
		"Finally, we have the [b]Match Corners and Sides[/b] mode, which is the most commonly used one.",
		"It allows you to create all the shapes from the previous two modes, plus a lot more! It notably supports more organic shapes like the ivy you can see in the viewport.",
		"This mode uses many more tiles and is the hardest to set up. You can see the full set of tiles in the image below:",
	])
	# TODO: replace
	# bubble_add_texture(load("res://assets/guides/match_corners_and_sides.png"))
	bubble_add_text([
		"[b]Note:[/b] There are art tools that help artists produce these tiles quickly and easily. The open-source web app [url=https://wareya.github.io/webtyler/]Webtyler[/url] is one of them. It allows artists to draw a few tiles and generates the rest for you."
	])
	complete_step()

	bubble_set_title("Opening the scene")
	highlight_filesystem_paths(["res://creating_tilesets.tscn"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Okay, with this overview of the modes, let's get back to our project and set up our own terrain auto-tiling.",
		"Open our scene where we'll continue working on our tileset."
	])
	bubble_add_task_open_scene("res://creating_tilesets.tscn")
	complete_step()

	bubble_set_title("Selecting the Ground node")
	highlight_scene_nodes_by_path(["CreatingTilesets/Ground"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Select the [b]Ground[/b] node that contains our tilemap. It should have our tileset assigned and at least one platform drawn from the previous tours."
	])
	bubble_add_task_select_nodes_by_path(["CreatingTilesets/Ground"])
	complete_step()

	bubble_set_title("Creating a terrain")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"Now let's set up our terrain auto-tiling. To start creating a terrain, we need to:",
		"1. Add a terrain set in the TileSet resource in the Inspector dock",
		"2. Then we create a terrain within that set",
		"3. Finally, we paint the terrain rules for each tile in the TileSet editor",
		"The terrain system was designed to give you some flexibility, and as a result, it can be a bit tricky to set up. I'll explain each of these elements as we go along."
	])
	complete_step()

	bubble_set_title("Adding a terrain set")
	highlight_inspector_properties(["tile_set"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"The first step is to create a terrain set in our TileSet resource. A terrain set determines the rule-set used by the terrain system to select the right tile variants based on neighboring tiles.",
		"Let's create the terrain set:",
		"1. In the [b]Inspector[/b] dock, expand the [b]Tile Set[/b] property",
		"2. Find the [b]Terrain Sets[/b] section in the TileSet resource",
		"3. Click the [b]Add Element[/b] button to create a new terrain set"
	])
	bubble_add_task(
		"Create a terrain set in the TileSet resource",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node: TileMapLayer = scene_root.find_child("Ground")
			return 1 if ground_node and ground_node.tile_set and ground_node.tile_set.get_terrain_sets_count() > 0 else 0
	)
	complete_step()

	bubble_set_title("Setting the terrain mode")
	highlight_inspector_properties(["terrain_set_0/mode"])
	bubble_add_text([
		"The terrain mode is the first property you need to set as it determines how the terrain system will select tiles.",
		"By default, the mode is set to [b]Match Corners and Sides[/b], which is the most flexible and commonly used one.",
		"It's the mode we'll be using in this tour so there's no need to change it."
	])
	complete_step()

	bubble_set_title("Creating a terrain")
	highlight_inspector_properties(["tile_set"])
	bubble_add_text([
		"Now, we need to create a terrain within our terrain set. This represents a specific type of tiles, like dirt platforms, ivy, or water, for example:",
		"1. In the [b]Inspector[/b], find the [b]Terrains[/b] property under [b]Terrain Set 0[/b]",
		"2. Click [b]Add Element[/b] to create a new terrain"
	])
	bubble_add_task(
		"Create a terrain in the terrain set",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node: TileMapLayer = scene_root.find_child("Ground")
			return 1 if ground_node and ground_node.tile_set and ground_node.tile_set.get_terrain_sets_count() > 0 and ground_node.tile_set.get_terrains_count(0) > 0 else 0
	)
	complete_step()

	bubble_set_title("Naming the terrain")
	highlight_inspector_properties(["terrain_set_0/terrain_0/name"])
	bubble_add_text([
		"Let's give our terrain a descriptive name.",
		"In the [b]Inspector[/b], set the [b]Name[/b] field for [b]Terrain 0[/b] to [b]Ground[/b].",
		"This name will show up in the TileSet and TileMap editors and help us identify the terrain."
	])
	bubble_add_task(
		"Rename the terrain to Ground",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node: TileMapLayer = scene_root.find_child("Ground")
			if ground_node and ground_node.tile_set:
				for terrain_set_idx in ground_node.tile_set.get_terrain_sets_count():
					for terrain_idx in ground_node.tile_set.get_terrains_count(terrain_set_idx):
						return 1 if ground_node.tile_set.get_terrain_name(terrain_set_idx, terrain_idx) == "Ground" else 0
			return 0
	)
	complete_step()

	bubble_set_title("Setting the terrain color")
	highlight_inspector_properties(["terrain_set_0/terrain_0/color"])
	bubble_add_text([
		"We can also set a distinctive color for when setting up the terrain. This color helps to contrast and distinguish the different terrains in the TileSet editor.",
		"As this terrain is for the ground tiles, which are a brown, earthy color, we can set the color to a light purple to help it stand out.",
		"In the [b]Inspector[/b], set the [b]Color[/b] field of the [b]Ground[/b] terrain to a light color. I used [b]#ebcded[/b] (a light purple)."
	])
	bubble_add_task(
		"Change the color of the terrain",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node: TileMapLayer = scene_root.find_child("Ground")
			if ground_node and ground_node.tile_set:
				for terrain_set_idx in ground_node.tile_set.get_terrain_sets_count():
					for terrain_idx in ground_node.tile_set.get_terrains_count(terrain_set_idx):
						return 1 if ground_node.tile_set.get_terrain_color(terrain_set_idx, terrain_idx) == Color("#ebcded") else 0
			return 0
	)
	complete_step()

	bubble_set_title("Opening the TileSet editor")
	highlight_controls([interface.bottom_tileset_button])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"We have the terrain set and terrain created, but we still need to set up the tiles in the TileSet editor.",
		"Let's open the [b]TileSet[/b] editor to set up our terrain tiles."
	])
	bubble_add_task_press_button(interface.bottom_tileset_button)
	complete_step()

	bubble_set_title("Accessing the Paint tab")
	highlight_controls([interface.tileset_tiles_atlas_editor_tools_paint_button])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"In the TileSet editor, click the [b]Paint[/b] button at the top of the editor.",
		"This tool allows us to paint tile properties like terrains with an editor tool rather than selecting and setting properties using the Inspector."
	])
	bubble_add_task_press_button(interface.tileset_tiles_atlas_editor_tools_paint_button)
	complete_step()

	bubble_set_title("Selecting the Terrains property")
	highlight_controls([interface.tileset_tiles_atlas_editor_paint])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"In the central column, click the button below the [b]Paint properties:[/b] label to reveal a list of properties you can paint.",
		"Select [b]Terrains[/b] in the list."
	])
	bubble_add_task(
		"Select the Terrains property in the Paint tab",
		1,
		func(_task: Task) -> int:
			if not interface.tileset_tiles_atlas_editor_tools_paint_button.button_pressed:
				return 0
			var button := interface.tileset_tiles_atlas_editor_paint.get_child(0).get_child(1)
			# TODO: probably needs translation
			return 1 if button.text == "Terrains" else 0
	)
	complete_step()

	bubble_set_title("Selecting the Ground terrain")
	highlight_controls([interface.tileset_tiles_atlas_editor_paint])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_add_text([
		"We now need to select which terrain set and terrain we want to paint.",
		"Set the [b]Terrain Set[/b] dropdown to [b]Terrain Set 0[/b] and the [b]Terrain[/b] dropdown to [b]Ground[/b].",
		"This will allow you to assign the [b]Ground[/b] terrain to the tiles."
	])
	# TODO: I added this additional task
	bubble_add_task(
		"Select the Terrain Set 0 and the Ground terrain under the Painting category",
		1,
		func(_task: Task) -> int:
			if not interface.tileset_tiles_atlas_editor_tools_paint_button.button_pressed:
				return 0
			for control in interface.tileset_tiles_atlas_editor_paint.get_child(0).get_child(-1).get_children():
				if control.get_class() == "TileDataTerrainsEditor":
					var option_button: OptionButton = control.get_child(-1).get_child(0)
					# TODO: check edge cases
					return 1 if option_button.get_item_text(option_button.selected) == "Ground" else 0
			return 0
	)
	complete_step()

	bubble_set_title("Adding tiles to the terrain")
	highlight_controls([interface.tileset_tiles_atlas_editor_atlas_view])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"First, we need to add all our relevant tiles to the terrain set. You can click each tile on the right to add it to the terrain set.",
		"When you click a tile, you'll see them light up and the minus symbol on them will disappear, meaning they are now part of the terrain set.",
		"To add tiles faster, press [b]Ctrl + Shift[/b] ([b]Cmd + Shift[/b] on macOS) and click and drag on the tiles you want to add. This will select all the tiles in the rectangle you dragged over."
	])
	complete_step()

	bubble_set_title("Understanding terrain bits")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"Now comes the challenging part! We need to tell the engine how the tiles should work together.",
		"Terrains use \"peering bits\" to determine how tiles connect to each other. Think of it like a jigsaw puzzle: each tile has a specific pattern that needs to match with the neighboring tiles.",
		"Each tile has one center bit that represents a filled grid cell and up to 8 terrain \"peering bits\" (for the corners and sides) that represent connections around the tiles. For example, if one tile has a peering bit on the right, the tile to the right must have a peering bit on the left.",
		"When auto-tiling, Godot will automatically select tiles based on these bits to create seamless transitions."
	])
	complete_step()

	bubble_set_title("Painting terrain bits")
	# Assuming there's some visualization of the bit pattern in the editor
	highlight_controls([interface.tileset_tiles_atlas_editor_atlas_view])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's start painting the peering bits for each tile. We need to paint according to this template:",
	])
	# TODO: replace
	# bubble_add_texture(load("res://assets/guides/terrain_peering_bit_template.png"))
	bubble_add_text([
		"You can paint and erase peering bits like this:",
		"- [b]Left click[/b] to insert a peering bit",
		"- [b]Right click[/b] to erase a peering bit",
		"Don't paint it all just yet! I'll guide you through the first few tiles, and then you can finish the rest."
	])
	complete_step()

	bubble_set_title("Painting the top-left corner tile")
	highlight_controls([interface.tileset_tiles_atlas_editor_atlas_view])
	bubble_add_text([
		"Let's set up the top-left corner tile as an example, the single tile platform:",
		"1. Click in the center to paint the center peering bit",
		"2. Click at the bottom to paint the bottom peering bit",
		"It tells Godot that this tile should be used when there's ground terrain below it."
	])
	# TODO: can't implement task, we don't have that level of access
	# bubble_add_task(
	# 	"Paint the center and bottom peering bits of the top left tile",
	# 	1,
	# 	func(_task: Task) -> int:
	# 		# In a real tour, we would need a way to check if the specific terrain bits were set
	# 		# This is a simplified placeholder
	# 		return 1
	# )
	complete_step()

	bubble_set_title("Painting the middle column tile")
	highlight_controls([interface.tileset_tiles_atlas_editor_atlas_view])
	bubble_add_text([
		"Now let's set up the middle tile for our vertical column platform. Paint the top, center, and bottom peering bits.",
		"This tells Godot that this tile should be used in the middle of a vertical column, connecting to terrain above and below it."
	])
	# TODO: can't implement task, we don't have that level of access
	# bubble_add_task(
	# 	"Paint the center and top and bottom peering bits of the highlighted tile",
	# 	1,
	# 	func(_task: Task) -> int:
	# 		# In a real tour, we would need a way to check if the specific terrain bits were set
	# 		# This is a simplified placeholder
	# 		return 1
	# )
	complete_step()

	bubble_set_title("Painting the bottom column tile")
	highlight_controls([interface.tileset_tiles_atlas_editor_atlas_view])
	bubble_add_text([
		"Now let's set up the bottom tile for our vertical column platform. For this one, you only need to paint the top and center peering bits.",
		"This tells Godot that this tile should be used at the bottom of a vertical column, connecting only to terrain above it."
	])
	# TODO: can't implement task, we don't have that level of access
	# bubble_add_task(
	# 	"Paint the top and center peering bits of the highlighted tile",
	# 	1,
	# 	func(_task: Task) -> int:
	# 		# In a real tour, we would need a way to check if the specific terrain bits were set
	# 		# This is a simplified placeholder
	# 		return 1
	# )
	complete_step()

	bubble_set_title("Opening the TileMap editor")
	highlight_controls([interface.bottom_tilemap_button])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Great job! You've set up the first three tiles. Now let's test our terrain auto-tiling.",
		"Go back to the [b]TileMap[/b] editor by clicking the [b]TileMap[/b] button at the bottom of the screen."
	])
	bubble_add_task_press_button(interface.bottom_tilemap_button)
	complete_step()

	bubble_set_title("Selecting the Terrains tab")
	highlight_tabs_title(interface.tilemap_tabs, "Terrains")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"In the TileMap editor, click the [b]Terrains[/b] tab.",
		"You should see our [b]Ground[/b] terrain listed there."
	])
	bubble_add_task_set_tab_to_title(interface.tilemap_tabs, "Terrains")
	complete_step()

	bubble_set_title("Selecting the Ground terrain")
	highlight_controls([interface.tilemap_terrains_tree])
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Select the [b]Ground[/b] terrain in the [b]Terrains[/b] tab. This will allow you to paint the terrain in the viewport."
	])
	bubble_add_task(
		"Select the Ground terrain",
		1,
		func(_task: Task) -> int:
			var selected := interface.tilemap_terrains_tree.get_selected()
			if selected:
				return 1 if selected.get_text(0) == "Ground" else 0
			return 0
	)
	complete_step()

	bubble_set_title("The Connect mode")
	highlight_controls([interface.tilemap_terrains_toolbar_paint_button, interface.tilemap_terrains_tiles])
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"By default, when selecting a terrain, Godot selects the %s [b]Connect[/b] paint mode." % [bbcode_generate_icon_image_by_name("TerrainConnect")],
		"This allows you to freely paint the terrain in the viewport. It automatically:",
		"1. Selects correct tiles based on existing neighboring tiles",
		"2. Updates surrounding tiles when you add or remove terrain",
		"This is much faster than manually selecting the right tile for each position!"
	])
	complete_step()

	bubble_set_title("Trying it out")
	highlight_controls([interface.canvas_item_editor_viewport])
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's try it out! Click and drag vertically in the viewport to paint some terrain.",
		"Currently, our terrain only supports drawing vertical columns, but we can add more shapes later.",
		"Make sure that you have the %s [b]Select Mode[/b] selected in the toolbar above the viewport. This is necessary to paint terrain." % [bbcode_generate_icon_image_by_name("ToolSelect")],
		"Left click in the viewport to paint terrain, and right click to erase it."
	])
	bubble_add_task(
		# TODO: rephrased to match the task result - exactly one column of terrain
		"Paint a vertical terrain column in the viewport",
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node: TileMapLayer = scene_root.find_child("Ground")
			var cells := ground_node.get_used_cells()
			if cells.size() < 2:
				return 0

			for idx in range(0, cells.size() - 1):
				if cells[idx].x != cells[idx + 1].x:
					return 0
			return 1
	)
	complete_step()

	bubble_set_title("Getting back to the TileSet editor")
	highlight_controls([interface.bottom_tileset_button])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Now that we have a working terrain, let's go back to the [b]TileSet[/b] editor to set up the rest of the tiles."
	])
	bubble_add_task_press_button(interface.bottom_tileset_button)
	complete_step()

	bubble_set_title("Completing the terrain bits")
	highlight_controls([interface.tileset_tiles_atlas_editor_atlas_view])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"This takes us back to the Ground tileset where we left off.",
		"Continue painting the peering bits for all the remaining ground tiles, using this template as a reference:",
	])
	# TODO: replace
	# bubble_add_texture(load("res://assets/guides/terrain_peering_bit_template.png"))
	bubble_add_text([
		"Here's a trick to help you out here and in your project: in most tilesets, the peering bits will fall exactly on the parts of the image that are not edges or shaded areas. In this case, you need to paint the light brown dirt bits and skip any grass or shaded parts.",
		"Take your time and be methodical: you need to paint the peering bits precisely to ensure the tiles connect correctly."
	])
	complete_step()

	bubble_set_title("Testing the terrain")
	highlight_controls([interface.bottom_tilemap_button])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"If you're done painting, you can test the terrain auto-tiling by going back to the [b]TileMap[/b] editor and painting some more terrain."
	])
	bubble_add_task_press_button(interface.bottom_tilemap_button)
	complete_step()

	bubble_set_title("Painting the terrain")
	highlight_controls([interface.canvas_item_editor_viewport])
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Try painting tiles in the viewport once again. If you followed the template closely, you should now be able to paint platforms of all shapes and sizes!"
	])
	complete_step()

	bubble_set_title("Congrats!")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"You've successfully set up terrain auto-tiling for your tileset!",
		"Your progress will be saved if you quit now.",
		"In the next tour, you'll switch focus to tilemaps and learn the tools at your disposal to draw and edit levels."
	])
	queue_command(func wink_avatar(): bubble.avatar.do_wink())
	complete_step()
