extends "../102_assemble_your_first_game.gd"


func bubble_add_task_select_node_by_name(node_name: String, description_override := "") -> void:
	var description := description_override
	if description.is_empty():
		description = gtr("Select the %s node in the [b]Scene Dock[/b].") % node_name
	bubble_add_task(
		description,
		1,
		func task_select_node(_task: Task) -> int:
			var selected_nodes := EditorInterface.get_selection().get_selected_nodes()
			if selected_nodes.size() == 0:
				return 0

			var scene_root := EditorInterface.get_edited_scene_root()
			var found := scene_root.find_child(node_name)
			if found == null:
				# Allow passing the step if the node was renamed by the user
				print_debug("Node not found: " + node_name)
				return 1

			for selected_node: Node in selected_nodes:
				if selected_node == found:
					return 1
			return 0
	)



func _build() -> void:
	# Set editor state according to the tour's needs.
	queue_command(func reset_editor_state_for_tour():
		interface.canvas_item_editor_toolbar_grid_button.button_pressed = false
		interface.canvas_item_editor_toolbar_smart_snap_button.button_pressed = false
		interface.bottom_output_button.button_pressed = false
	)

	part_010_updating_health_bar()


func part_010_updating_health_bar() -> void:

	add_step_open_start_scene_conditionally()

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Updating the health bar"))
	bubble_add_text([
		gtr("We have a problem. When we touch an enemy, the character loses one health point, but this is not reflected in the health bar."),
		gtr("This is because the [b]UIHealthBar[/b] node is [b]not connected[/b] to changes in the [b]Player[/b] node."),
	])
	queue_command(func():
		interface.bottom_output_button.button_pressed = false
	)
	complete_step()

	bubble_set_title(gtr("Updating the health bar"))
	bubble_add_text([
		gtr("Godot comes with a handy feature to react to changes in a node, like the player's health changing: [b]signals[/b]."),
		gtr("In this project, when the player takes damage, the [b]Player[/b] node [b]emits[/b] a signal called [b]health_changed[/b]."),
		gtr("We need to [b]connect[/b] this signal to the [b]UIHealthBar[/b] node to update the health bar.")
	])
	complete_step()
	highlight_scene_nodes_by_path(["Start/Player"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Select the player node"))
	bubble_add_text([
		gtr("To see and connect the signals of a node, we first need to select that node."),
		gtr("So once again, select the [b]Player[/b] node in the [b]Scene Dock[/b]."),
	])
	bubble_add_task_select_node_by_name("Player")
	complete_step()

	highlight_tabs_title(interface.inspector_tabs, "Node")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("The Node Dock"))
	bubble_add_text([
		gtr("Next to the [b]Inspector[/b] dock on the right lives the [b]Node dock[/b]. The node dock lists the selected node's signals."),
		gtr("The node dock is located in its own tab next to the tab of the [b]Inspector[/b] dock."),
		gtr("Click on the Node tab in the top-right to select the Node dock."),
	])
	bubble_add_task_set_tab_by_control(interface.node_dock)
	complete_step()

	highlight_controls([interface.node_dock_signals_editor])
	bubble_move_and_anchor(interface.main_screen, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("All the signals"))
	bubble_add_text([
		gtr("As you can see, the player node has many signals. Most of them come built into Godot."),
		gtr("Throughout the course, you will learn to use the most useful ones."),
		gtr("At the top of the list, notice the [b]health_changed[/b] signal."),
	])
	complete_step()

	highlight_signals(["health_changed"])
	queue_command(interface.signals_dialog_window.hide)
	bubble_set_title(gtr("Connect the health_changed signal"))
	bubble_add_text([
		gtr("Let's connect the signal."),
		gtr("Double-click the [b]health_changed[/b] signal to open the window [b]Connect a Signal to a Method[/b]."),
	])
	bubble_add_task(
		gtr("Double-click the [b]health_changed[/b] signal "),
		1,
		func(_task: Task) -> int: return 1 if interface.signals_dialog_window.visible else 0,
	)
	complete_step()

	queue_command(interface.signals_dialog_window.set_position, [popup_window_position])
	highlight_controls([interface.signals_dialog])
	bubble_move_and_anchor(interface.main_screen, Bubble.At.CENTER_RIGHT)
	bubble_set_title(gtr("The connect signal window"))
	bubble_add_text([
		gtr("This window on the left is the [b]Connect a Signal to a Method[/b] window. It lists all the nodes in your scene."),
		gtr("Many nodes are greyed out. This is because we can only connect signals to a node that has a code file %s attached to it, like the [b]UIHealthBar[/b] node.") % bbcode_generate_icon_image_string(ICONS_MAP.script),
	])
	complete_step()

	highlight_controls([interface.signals_dialog_method_line_edit], true)
	bubble_set_title(gtr("The called function"))
	bubble_add_text([
		gtr("At the bottom of the window, Godot lets us pick a \"Receiver Method\"."),
		gtr("This is a piece of code that Godot will run when the player node emits the [b]health_changed[/b] signal."),
		gtr("We can keep the default value."),
		gtr("You will learn more about what a [b]method[/b] (also called a function) is in the next module, where we'll learn to write code."),
	])
	complete_step()

	highlight_controls([interface.signals_dialog_tree])
	bubble_set_title(gtr("Connect the signal"))
	bubble_add_text([
		gtr("To connect the signal, double-click on the [b]UIHealthBar[/b] node."),
		gtr("You may need to scroll down the list to find it. You can do so using the [b]Mouse Wheel[/b] or by clicking and dragging on the scrollbar on the right."),
		gtr("This will immediately take you to the code file attached to the UI health bar node."),
	])
	bubble_add_task(
		gtr("Double-click on the [b]UIHealthBar[/b] node."),
		1,
		func(_task: Task) -> int:
			var player_node: Node = get_scene_node_by_path("Start/Player")
			if player_node == null:
				var found_nodes := get_scene_nodes_by_prefix("Player")
				if found_nodes.size() > 0:
					player_node = found_nodes.front()
			# Allow passing the step if the player node was renamed by the user
			# and cannot be found.
			if player_node == null:
				return 1
			return 0 if player_node.get_signal_connection_list("health_changed").is_empty() else 1,
	)
	complete_step()

	highlight_controls([interface.script_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_title(gtr("Excellent!"))
	bubble_add_text([
		gtr("You are now looking at the code file attached to the [b]UIHealthBar[/b] node."),
		gtr("Don't worry if the code doesn't make sense yet. You will learn to read and write code throughout the course."),
	])
	complete_step()

	highlight_code(26, 29)
	bubble_set_title(gtr("The connected function"))
	bubble_add_text([
		gtr("Your signal is now connected to the function named [b]_on_player_health_changed[/b]."),
		gtr("Godot indicates the connection with the green icon %s in the margin on the left.") % bbcode_generate_icon_image_string(ICONS_MAP.script_signal_connected),
	])
	complete_step()

	highlight_controls([interface.run_bar_play_current_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Time to play!"))
	bubble_add_text([
		gtr("Let's see if everything works as expected."),
		gtr("Click the [b]Play Current Scene[/b] button and go fight some baddies."),
		gtr("When you touch an enemy and lose health, the health bar should now update accordingly."),
	])
	bubble_add_task_press_button(interface.run_bar_play_current_button, gtr("Play Current Scene"))
	complete_step()


	bubble_set_title(gtr("In summary"))
	queue_command(func set_avatar_happy() -> void:
		bubble.avatar.set_expression(Gobot.Expressions.HAPPY)
	)
	bubble_add_text([
		gtr("In this part, you learned where to find the list of signals a node emits and how to connect a signal to a function. Thanks to this, the player can now see their health decreasing when they take damage."),
		gtr("In the next and last part, you will add a chest to one of the room scenes and write your first line of code to complete the game."),
	])
	complete_step()
