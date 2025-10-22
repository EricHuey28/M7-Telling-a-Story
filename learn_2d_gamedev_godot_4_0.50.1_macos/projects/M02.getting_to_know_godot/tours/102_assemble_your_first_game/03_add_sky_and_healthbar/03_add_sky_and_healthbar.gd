extends "../102_assemble_your_first_game.gd"


func _build() -> void:
	# Set editor state according to the tour's needs.
	queue_command(func reset_editor_state_for_tour():
		interface.canvas_item_editor_toolbar_grid_button.button_pressed = false
		interface.canvas_item_editor_toolbar_smart_snap_button.button_pressed = false
		interface.bottom_output_button.button_pressed = false
	)

	part_010_adding_sky()
	part_020_adding_health_bar()


func part_010_adding_sky() -> void:

	add_step_open_start_scene_conditionally()

	bubble_set_title(gtr("Fleshing out the game"))
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		gtr("You will usually start creating a game with the character and level structure, then flesh out the background and add user interface."),
		gtr("We have the playable character and level, so we'll add a sky and health bar next."),
		gtr("The background is a dull flat color. Let's start with the sky."),
		]
	)
	queue_command(func():
		interface.bottom_output_button.button_pressed = false
	)
	complete_step()

	highlight_scene_nodes_by_path(["Start"])
	bubble_set_title(gtr("Re-select the Start node"))
	bubble_add_text([
		gtr("We usually add background elements as children of the scene root node to keep the scene organized."),
		gtr("In this case, the scene root node is the [b]Start[/b] node."),
		gtr("Click on the [b]Start[/b] node in the [b]Scene Dock[/b] to re-select it."),
	])
	bubble_add_task_select_nodes_by_path(["Start"])
	complete_step()

	bubble_set_title(gtr("Add the sky scene"))
	highlight_controls([interface.canvas_item_editor])
	highlight_filesystem_paths([SCENE_BACKGROUND_SKY])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		gtr("Drag and drop the [b]%s[/b] file onto the viewport to create an instance of it.") % SCENE_BACKGROUND_SKY.get_file(),
		gtr("This will add the sky to the game as a child of the selected [b]Start[/b] node."),
		]
	)
	bubble_add_task(
		gtr("Add the [b]Background Blue Sky Scene[/b] to the [b]Scene[/b]."),
		1,
		func(_task: Task) -> int:
			var player: Node = get_scene_node_by_path("Start/BackgroundBlueSky")
			return 1 if player != null else 0,
	)
	complete_step()

	bubble_set_title(gtr("Perfect!"))
	highlight_controls([interface.run_bar_play_current_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		gtr("Run the game to see how the sky always fills up the background and improves the experience."),
		gtr("A game's feel improves with all the little things you add: background, animations, sounds, special effects..."),
		gtr("Click the [b]Play Edited Scene[/b] button to run the scene."),
	])
	bubble_add_task_press_button(interface.run_bar_play_current_button, gtr("Play Edited Scene"))
	complete_step()


func part_020_adding_health_bar() -> void:
	bubble_set_title(gtr("Adding user interface"))
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		gtr("Our next task is to add a health bar to see when the character takes damage."),
		gtr("Until now, we've only created scene instances. This time, we will also create a node."),
	])
	queue_command(func():
		interface.bottom_output_button.button_pressed = false
	)
	complete_step()

	bubble_set_title(gtr("The CanvasLayer node"))
	bubble_add_text([
		gtr("When we add visual elements to the game, by default, they don't move with the player."),
		gtr("For the user interface, we want it to move with the player so it always stays on screen."),
		gtr("We can use a [b]CanvasLayer node[/b] for this. By default, it keeps visuals we add as a child of it on screen at all times."),
		gtr("Let's add a CanvasLayer node to the scene so that our user interface moves with the player."),
	])
	complete_step()

	highlight_scene_nodes_by_path(["Start"])
	bubble_set_title(gtr("Select the Start node"))
	bubble_add_text([
		gtr("We want to add the [b]CanvasLayer[/b] node as a child of the [b]Start[/b] node, [b]not[/b] as a child of the currently selected [b]BackgroundBlueSky[/b], to keep our scene hierarchy organized."),
		gtr("Click on the [b]Start[/b] node in the [b]Scene Dock[/b] to select it."),
	])
	bubble_add_task_select_nodes_by_path(["Start"])
	complete_step()


	queue_command(func reposition_window_on_visibility_changed():
		interface.node_create_window.visibility_changed.connect(interface.node_create_window.set_position.bind(popup_window_position), CONNECT_ONE_SHOT)
		interface.node_create_window.grab_focus()
		interface.node_create_window.set_max_size(popup_window_max_size),
	)
	queue_command(func node_create_window_disable_cancel_button():
		interface.node_create_dialog_button_cancel.disabled = true
	)
	highlight_controls([interface.scene_dock_add_button, interface.node_create_panel], true)
	bubble_set_title(gtr("The Create Node dialog"))
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		gtr("To add a node, click on the plus icon in the top-left of the [b]Scene Dock[/b], or press [b]%s + A[/b] on your keyboard.") % shortcuts.ctrl,
		gtr("This will open a popup window listing all the types of nodes built into Godot."),
	])
	bubble_add_task_press_button(interface.scene_dock_add_button)
	complete_step()

	queue_command(interface.node_create_window.grab_focus)
	queue_command(interface.node_create_window.set_position, [popup_window_position])
	queue_command(interface.node_create_window.set_max_size, [popup_window_max_size])
	highlight_controls([interface.node_create_panel])
	bubble_set_title(gtr("Godot's built-in nodes"))
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		gtr("This popup window is the [b]Create Node[/b] dialog."),
		gtr("It lists over 100 node types Godot provides out of the box!"),
		gtr("Each has a specific purpose, like displaying an image, playing a sound, or letting you draw with a tilemap."),
	])
	complete_step()

	highlight_controls([interface.node_create_dialog_search_bar, interface.node_create_dialog_node_tree, interface.node_create_dialog_button_create])
	queue_command(interface.node_create_dialog_search_bar.grab_focus)
	bubble_set_title(gtr("Add the CanvasLayer node"))
	bubble_add_text([
		gtr("We need to add a [b]CanvasLayer node[/b]."),
		gtr("Click the search bar at the top to select it and search the node list. It's the fastest way to find nodes."),
		gtr("In the central panel of the popup window, click on the [b]CanvasLayer[/b] node to select it."),
		gtr("Then, click the [b]Create[/b] button at the bottom of the window to add the node (or press the [b]Enter[/b] key on your keyboard)."),
	])
	bubble_add_task(
		gtr("Create the [b]CanvasLayer[/b] node."),
		1,
		func(_task: Task) -> int:
			var selected_nodes := EditorInterface.get_selection().get_selected_nodes()
			return 1 if selected_nodes.size() > 0 and selected_nodes.any(func(node: Node): return node is CanvasLayer) else 0,
	)
	complete_step()

	queue_command(func node_create_window_enable_cancel_button():
		interface.node_create_dialog_button_cancel.disabled = false
	)
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Great job!"))
	bubble_add_text([
		gtr("You just created your first node. Godot automatically selects a newly created node for you, so that you can immediately change its properties in the Inspector on the right."),
		gtr("Let's add the health bar next."),
	])
	complete_step()

	highlight_scene_nodes_by_name(["CanvasLayer"])
	highlight_filesystem_paths([SCENE_HEALTH_BAR])
	bubble_move_and_anchor(interface.main_screen, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Add the health bar"))
	bubble_add_text([
		gtr("To stay on screen at all times, the health bar must be a child of the [b]CanvasLayer[/b] node."),
		gtr("Drag and drop the [b]%s[/b] scene onto the [b]CanvasLayer[/b] node in the [b]Scene Dock[/b] to create an instance of it.") % SCENE_HEALTH_BAR.get_file(),
		gtr("Dragging the scene onto a node in the [b]Scene Dock[/b] creates the instance as a child of the node."),
	])
	bubble_add_task(
		gtr("Add the [b]Health Bar Scene[/b] to the [b]Scene[/b]."),
		1,
		func(_task: Task) -> int:
			var root := EditorInterface.get_edited_scene_root()
			var health_bar: Control = root.find_child("UIHealthBar")
			return 1 if health_bar != null else 0,
	)
	mouse_click()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(interface.filesystem_tree, SCENE_HEALTH_BAR),
		get_tree_item_center_by_name.bind(interface.scene_tree, "CanvasLayer"),
	)
	mouse_click()
	complete_step()

	scene_select_nodes_by_path(["Start/CanvasLayer/UIHealthBar"])
	canvas_item_editor_flash_area(Rect2(0, 0, 1920, 1080))
	highlight_controls([interface.canvas_item_editor])
	bubble_set_title(gtr("The screen area"))
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		gtr("We need to ensure that the health bar is positioned correctly to be visible on-screen."),
		gtr("In the viewport, four thin lines are forming a rectangle. They represent the extent of the game window, the window that opens when you run the game."),
		gtr("The four lines can be difficult to spot as they're thin. Look at the flashing area in the viewport. It highlights this window extent area."),
		gtr("Any user interface you want to keep on-screen in the game should be placed inside this rectangle."),
	])
	canvas_item_editor_center_at(Vector2(960, 540), 0.5)
	complete_step()


	highlight_inspector_properties(["position"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Place the health bar on-screen"))

	bubble_add_text([
		gtr("Let's learn a third way to move an element: using the [b]Inspector[/b] and typing coordinates manually."),
		gtr("We currently have the [b]UIHealthBar[/b] node selected in the [b]Scene[/b] dock."),
		gtr("On the right, in the [b]Inspector Dock[/b], in the section [b]Layout -> Transform[/b], you can find the [b]Position[/b] property."),
		gtr("Earlier, when you moved and placed rooms around the viewport with the select and move modes, you changed the [b]Position[/b] property of individual rooms."),
	])
	complete_step()

	highlight_inspector_properties(["position"])
	bubble_set_title(gtr("The position property"))
	bubble_add_text([
		gtr("The Position property has two coordinates: the [b]x[/b] coordinate controls the [b]horizontal[/b] position of the health bar, and the [b]y[/b] coordinate controls its [b]vertical[/b] position."),
		gtr("Click the number of each coordinate to edit it. Type a new number and press [b]Enter[/b] on your keyboard to confirm the new value."),
		gtr("Change the x coordinate to 60, and the y coordinate to 60 as well. This will place the health bar in the top-left corner of the game window when playing."),
	])
	bubble_add_task(
		gtr("Set the [b]x Position[/b] property of the [b]UIHealthBar[/b] to [b]60px[/b] (pixels)."),
		1,
		func(_task: Task) -> int:
			var root := EditorInterface.get_edited_scene_root()
			var health_bar: Control = root.find_child("UIHealthBar")
			return 1 if is_equal_approx(health_bar.position.x, 60) else 0,
	)
	bubble_add_task(
		gtr("Set the [b]y Position[/b] property of the [b]UIHealthBar[/b] to [b]60px[/b] (pixels)."),
		1,
		func(_task: Task) -> int:
			var root := EditorInterface.get_edited_scene_root()
			var health_bar: Control = root.find_child("UIHealthBar")
			return 1 if is_equal_approx(health_bar.position.y, 60) else 0,
	)
	complete_step()

	highlight_controls([interface.run_bar_play_current_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Excellent!"))
	bubble_add_text([
		gtr("You know what time it is? Yes, let's run the scene!"),
		gtr("Click the [b]Play Current Scene[/b] button and pay attention to how the health bar stays on screen as your progress through the level."),
		gtr("Also, try to go touch an enemy and pay attention to what happens to the health bar."),
	])
	bubble_add_task_press_button(interface.run_bar_play_current_button, gtr("Play Current Scene"))
	complete_step()

	bubble_set_title(gtr("In summary"))
	queue_command(func set_avatar_happy() -> void:
		bubble.avatar.set_expression(Gobot.Expressions.HAPPY)
	)
	bubble_add_text([
		gtr("You added a background and a health bar to the game. Most importantly, you learned to create a node and add the health bar as a child of it to make the user interface stay on screen."),
		gtr("In the next part, you'll use signals to connect the health bar to the player's health."),
	])
	complete_step()
