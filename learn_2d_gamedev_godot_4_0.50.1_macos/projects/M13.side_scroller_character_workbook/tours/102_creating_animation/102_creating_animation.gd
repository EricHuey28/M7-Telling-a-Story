extends "res://addons/godot_tours/tour.gd"

const TEXTURE_BUBBLE_BACKGROUND := preload("res://assets/bubble-background.png")
const TEXTURE_GDQUEST_LOGO := preload("res://assets/gdquest-logo.svg")

const CREDITS_FOOTER_GDQUEST := "[center]Godot Interactive Tours · Made by [url=https://www.gdquest.com/][b]GDQuest[/b][/url] · [url=https://github.com/GDQuest][b]Github page[/b][/url][/center]"

# Helper function to get the AnimatedSprite2D node created in this tour from the scene
func get_animated_sprite_node() -> AnimatedSprite2D:
	var scene_root = EditorInterface.get_edited_scene_root()
	return scene_root as AnimatedSprite2D


func _build() -> void:
	context_set_2d()
	# Introduction
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size("[center][b]Creating an animation[/b][/center]", 32)])
	bubble_add_text([
		"[center]Now that you know the SpriteFrames editor's interface, let's create a new animation from the ground up.[/center]",
		"[center]In this tour, you'll learn the workflow for setting up looping character animations that you can use in your own games.[/center]",
		"[center][b]Let's get started![/b][/center]",
	])
	bubble_set_footer(CREDITS_FOOTER_GDQUEST)
	queue_command(func wink_avatar(): bubble.avatar.do_wink())
	complete_step()

	# Step 1: Creating a new scene
	bubble_set_title("Creating a new scene")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_LEFT)
	highlight_controls([interface.menu_bar], true)
	bubble_add_text([
		"Let's create our own animated sprite from scratch!",
		"Create a new scene by going to the Scene menu and selecting [b]New Scene[/b]."
	])
	bubble_add_task(
		"Create a new scene.",
		1,
		func task_create_new_scene(_task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 1
			return 0
	)
	complete_step()

	# Step 2: Adding an AnimatedSprite2D node
	bubble_set_title("Adding an AnimatedSprite2D node")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_LEFT)
	highlight_controls([interface.scene_dock_add_button], true)
	bubble_add_text([
		"Now click the " + bbcode_generate_icon_image_by_name("Add") + " [b]Add Node[/b] button at the top left of the Scene dock to open the node creation dialog.",
		"When the [b]Create New Node[/b] dialog appears, search for [b]AnimatedSprite2D[/b] and double-click it to add it to your scene."
	])
	bubble_add_task(
		"Create an AnimatedSprite2D node.",
		1,
		func task_created_animated_sprite_node(_task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			# Check if there is an AnimatedSprite2D node as root or child
			if scene_root is AnimatedSprite2D:
				return 1

			for child in scene_root.get_children():
				if child is AnimatedSprite2D:
					return 1

			return 0
	)
	complete_step()

	# Step 3: Creating a SpriteFrames resource
	bubble_set_title("Creating a SpriteFrames resource")
	queue_command(func force_zoom():
		canvas_item_editor_center_at()
		interface.canvas_item_editor_zoom_reset_button.pressed.emit()
		interface.canvas_item_editor_zoom_in_button.pressed.emit()
		interface.canvas_item_editor_zoom_in_button.pressed.emit()
		interface.canvas_item_editor_zoom_in_button.pressed.emit()
		interface.canvas_item_editor_center_button.pressed.emit()
	)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	highlight_inspector_properties(["sprite_frames"])
	bubble_add_text([
		"The [b]AnimatedSprite2D[/b] node needs a [b]SpriteFrames[/b] resource to hold all its animations and frames.",
		"In the [b]Inspector[/b], ensure the Animation category is expanded and locate the [b]Sprite Frames[/b] property, which is currently empty.",
		"Click the dropdown arrow next to the empty field and select " + bbcode_generate_icon_image_by_name("SpriteFrames") + " [b]New SpriteFrames[/b] to create the resource."
	])
	bubble_add_task(
		"Create a SpriteFrames resource.",
		1,
		func task_create_spriteframes_resource(_task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			var animated_sprite = null
			if scene_root is AnimatedSprite2D:
				animated_sprite = scene_root
			else:
				for child in scene_root.get_children():
					if child is AnimatedSprite2D:
						animated_sprite = child
						break

			if animated_sprite == null:
				return 0

			return 1 if animated_sprite.sprite_frames != null else 0
	)
	complete_step()

	# Step 4: Opening the SpriteFrames editor
	bubble_set_title("Opening the SpriteFrames editor")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	highlight_inspector_properties(["sprite_frames"])
	highlight_controls([interface.spriteframes])
	bubble_add_text([
		"Click on the newly created [b]SpriteFrames[/b] resource in the Inspector. This will open the SpriteFrames editor at the bottom of the screen."
	])
	bubble_add_task(
		"Open the SpriteFrames editor.",
		1,
		func task_open_spriteframes_editor(_task: Task) -> int:
			return 1 if interface.spriteframes.visible else 0
	)
	complete_step()

	# Step 5: Renaming the default animation
	bubble_set_title("Renaming the default animation")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	highlight_controls([interface.spriteframes_animations], true)
	bubble_add_text([
		"You'll notice a \"default\" animation has already been created for you. Let's rename it to better match the animation we'll create.",
		"Click on [b]default[/b] in the animation list to rename it. Type [b]run[/b] and press Enter.",
		"It's important to give animations meaningful names because those are the names you'll use to play them in your GDScript code."
	])
	bubble_add_task(
		"Rename the default animation to 'run'.",
		1,
		func task_rename_animation_to_run(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			if animated_sprite == null or animated_sprite.sprite_frames == null:
				return 0
			return 1 if animated_sprite.sprite_frames.has_animation("run") else 0
	)
	complete_step()

	# Step 6: Adding frames to an animation
	bubble_set_title("Adding frames to an animation")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	var run_frames: Array[String] = []
	for i in range(6):
		run_frames.append("res://assets/lucy/run/%03d.png" % i)
	highlight_filesystem_paths(run_frames, false)
	bubble_add_text([
		"There are multiple ways to add frames to an animation. The easiest method is to drag and drop images from the FileSystem dock.",
		"Notice the folder [b]res://assets/lucy/run[/b] in the [b]FileSystem[/b] dock. That's where the sprites for Lucy's run animation are stored.",
	])
	complete_step()

	# Step 7: Selecting multiple frames
	bubble_set_title("Selecting multiple frames")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_filesystem_paths(run_frames, false)
	bubble_add_text([
		"Let's add frames to the run animation. To add multiple frames at once:",
		"[ul][b]Left click[/b] on the first image file, [b]000.png[/b]\n" +
		"Hold [b]Shift[/b] and [b]left click[/b] on the last file, [b]005.png[/b][/ul]",
		"",
		"This selects all frames in between."
	])
	bubble_add_task(
		"Select all 6 run animation frames.",
		1,
		func task_select_all_anim_frames(_task: Task) -> int:
			# Verify that all run_frames are in the selection
			var selected_paths = EditorInterface.get_selected_paths()
			if selected_paths.size() != 6:
				return 0

			for path in run_frames:
				if not selected_paths.has(path):
					return 0
			return 1
	)
	mouse_click()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(interface.filesystem_tree, run_frames.front()),
		get_tree_item_center_by_path.bind(interface.filesystem_tree, run_frames.back())
	)
	mouse_click()
	complete_step()

	# Step 8: Drag and drop frames
	bubble_set_title("Drag and drop frames")
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	highlight_filesystem_paths(run_frames, false)
	highlight_controls([interface.spriteframes_frames_list], false)
	bubble_add_text([
		"With the frames selected, drag and drop them into the [b]Frames View[/b] in the right side of the SpriteFrames editor.",
		"All the selected frames will be added to your [b]run[/b] animation in sequence."
	])
	bubble_add_task(
		"Add the 6 run frames to the animation.",
		1,
		func task_add_6_frames(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			if animated_sprite == null or animated_sprite.sprite_frames == null:
				return 0
			var animation_name := "run"
			if not animated_sprite.sprite_frames.has_animation("run"):
				var names := animated_sprite.sprite_frames.get_animation_names()
				animation_name = names[0] if names.size() > 0 else "default"
			return 1 if animated_sprite.sprite_frames.get_frame_count(animation_name) == 6 else 0
	)
	mouse_click()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(interface.filesystem_tree, run_frames[run_frames.size() / 2]),
		get_control_global_center.bind(interface.spriteframes_frames_list)
	)
	mouse_click()
	complete_step()

	# Step 9: Looping animations
	bubble_set_title("Looping animations")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	highlight_controls([interface.spriteframes_animation_toolbar_looping_button], true)
	bubble_add_text([
		"By default, animations are set to loop, meaning they'll play continuously rather than stopping after one cycle.",
		"You can toggle animation looping by clicking the " + bbcode_generate_icon_image_by_name("Loop") + " [b]Loop[/b] icon above the animation list. For a run animation, we want looping enabled (the icon should be highlighted blue)."
	])
	bubble_add_task_toggle_button(
		interface.spriteframes_animation_toolbar_looping_button,
		true,
	)
	complete_step()

	# Step 10: Previewing your animation
	bubble_set_title("Previewing your animation")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	canvas_item_editor_center_at()
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	highlight_controls([interface.canvas_item_editor], false)
	highlight_controls([interface.spriteframes_frames_toolbar_play_button], true)
	bubble_add_text([
		"Let's see how the animation looks!",
		"Click the " + bbcode_generate_icon_image_by_name("Play") + " [b]Play[/b] button to preview your animation."
	])
	bubble_add_task_press_button(
		interface.spriteframes_frames_toolbar_play_button,
		"Play the animation."
	)
	complete_step()

	# Step 11: Adjusting animation speed
	bubble_set_title("Adjusting animation speed")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.canvas_item_editor])
	highlight_controls([interface.spriteframes_animation_toolbar_speed], true)
	bubble_add_text([
		"Our run animation currently is too slow because the default animation framerate is low.",
		"We can adjust this by changing its frame rate using the [b]FPS[/b] (Frames Per Second) field above the animation list.",
		"Change the FPS value from [b]5.0[/b] to [b]10.0[/b].",
		"Think of this like a flipbook: higher FPS means flipping through the frames faster. It also makes the animation more fluid."
	])
	bubble_add_task(
		"Change the FPS value to 10.0.",
		1,
		func task_change_fps_value(_task: Task) -> int:
			# Check if the animation speed is 10.0 FPS
			if is_equal_approx(interface.spriteframes_animation_toolbar_speed.value, 10.0):
				return 1
			return 0
	)
	complete_step()

	# Step 12: Previewing the adjusted animation
	bubble_set_title("Previewing the adjusted animation")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.canvas_item_editor])
	bubble_add_text([
		"Great job! Because the animation is looping, you can immediately see how the speed change affects the animation.",
		"For a running animation, 10-12 FPS usually gives a good result for pixel art characters."
	])
	complete_step()

	# Conclusion
	bubble_set_title("Conclusion")
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_add_text([
		"Congratulations! You've completed the basics of using the [b]AnimatedSprite2D[/b] node to create flipbook-style animations in Godot.",
		"You've learned how to:",
		"[ul]Create and rename animations\n" +
		"Change animation playback settings like speed and looping\n" +
		"Add frames by dragging image files into the editor\n" +
		"Preview your animations directly in the editor[/ul]",
		"",
		"In the next tour, we'll explore more tools to adjust the timing of individual frames, copy and paste frames, and create more complex animation patterns."
	])
	complete_step()
