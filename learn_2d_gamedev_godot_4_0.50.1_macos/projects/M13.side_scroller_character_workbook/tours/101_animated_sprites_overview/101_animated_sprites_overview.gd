extends "res://addons/godot_tours/tour.gd"

const TEXTURE_BUBBLE_BACKGROUND := preload("res://assets/bubble-background.png")
const TEXTURE_GDQUEST_LOGO := preload("res://assets/gdquest-logo.svg")

const CREDITS_FOOTER_GDQUEST := "[center]Godot Interactive Tours · Made by [url=https://www.gdquest.com/][b]GDQuest[/b][/url] · [url=https://github.com/GDQuest][b]Github page[/b][/url][/center]"

func _build() -> void:
	context_set_2d()
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size("[center][b]Overview of the animated sprite editor[/b][/center]", 32)])
	bubble_add_text([
		"[center]In this tour, you'll get an overview of Godot's built-in editor to set up flipbook animations for your 2D games.[/center]",
		"[center]We can access this editor through the [b]AnimatedSprite2D[/b] node. This node plays frame-by-frame animations loaded from sequences of images.[/center]",
		"[center]It's the traditional way of making animations and it works well for pixel art games or when you have a traditional animator in your team.[/center]",
		"[center]The next two tours will guide you through the process of setting up animations step-by-step.[/center]",
		"[center][b]Let's get started![/b][/center]",
	])
	bubble_set_footer(CREDITS_FOOTER_GDQUEST)
	queue_command(func wink_avatar(): bubble.avatar.do_wink())
	complete_step()

	bubble_set_title("What is AnimatedSprite2D?")
	bubble_add_text([
		"The [b]AnimatedSprite2D[/b] node is a slightly more powerful variant of the Sprite2D node that supports 2D flipbook style animations out of the box.",
		"It comes with a dedicated editor to set up hand-drawn frame by frame animations easily.",
		"It's perfect for character animations in pixel art games."
	])
	complete_step()

	scene_open("res://tours/animated_sprite_completed.tscn")
	bubble_set_title("See the finished result")
	highlight_controls([interface.canvas_item_editor, interface.scene_dock])
	queue_command(func force_zoom():
		interface.canvas_item_editor_zoom_reset_button.pressed.emit()
		interface.canvas_item_editor_zoom_in_button.pressed.emit()
		interface.canvas_item_editor_zoom_in_button.pressed.emit()
		interface.canvas_item_editor_zoom_in_button.pressed.emit()
		interface.canvas_item_editor_center_button.pressed.emit.call_deferred()
	)
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"I've opened a scene with an animated character using the [b]AnimatedSprite2D[/b] node.",
		"This character has four animations: \"Fall\", \"Idle\", \"Jump\", and \"Run.\" These animations can be triggered during gameplay.",
	])
	bubble_add_task_select_nodes_by_path(["AnimatedSprite2D"])
	complete_step()

	bubble_set_title("The SpriteFrames editor")
	highlight_controls([interface.spriteframes])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"Because this node already has animations set up, selecting it opens the corresponding bottom panel: the [b]SpriteFrames[/b] editor.",
		"Let's run through the different parts of the editor.",
	])
	complete_step()

	bubble_set_title("The animation list")
	highlight_controls([interface.spriteframes_animation])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"On the left side of the SpriteFrames editor is the [b]Animation List[/b].",
		"This area displays all animations for your sprite. You can add, remove, rename, and select animations here.",
		"Each character or object can have multiple animations like \"Idle\", \"Run\", or \"Jump\", and you can play any of them in the running game."
	])
	complete_step()

	bubble_set_title("Animation toolbar controls")
	highlight_controls([interface.spriteframes_animation_toolbar])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Above the animation list, you'll find controls to manage animations:",
		"[ul]The three icons on the left " + bbcode_generate_icon_image_by_name("New") + " create, " + bbcode_generate_icon_image_by_name("Duplicate") + " duplicate, or " + bbcode_generate_icon_image_by_name("Remove") + " delete animations\n" +
		"The " + bbcode_generate_icon_image_by_name("AutoPlay") + " [b]Autoplay on Load[/b] icon determines if the animation plays automatically when the game starts\n" +
		"The " + bbcode_generate_icon_image_by_name("Loop") + " [b]Animation Looping[/b] toggle button determines if animations repeat\n" +
		"The [b]FPS[/b] field controls the selected animation's speed in frames per second[/ul]"
	])
	complete_step()

	bubble_set_title("The frames view")
	highlight_controls([interface.spriteframes_frames])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"The area on the right is the [b]Frames View[/b], which displays all individual sprite frames in the currently selected animation.",
		"Each frame represents one image in your flipbook animation sequence. When played in order at the specified speed, these frames create the illusion of movement."
	])
	complete_step()

	bubble_set_title("Frames toolbar controls")
	highlight_controls([interface.spriteframes_frames_toolbar])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"At the top of the frames view, you'll find a toolbar with buttons to play and edit your animation:",
		"[ul]On the left are the animation playback controls\n" +
		"The next buttons add, copy, move, and delete frames\n" +
		"The [b]Frame Duration[/b] field controls the duration of the selected frames relative to the others[/ul]"
	])
	complete_step()

	bubble_set_title("Try playing an animation")
	highlight_controls([
		interface.spriteframes_animation,
		interface.spriteframes_frames_toolbar_play_button,
		interface.canvas_item_editor
	])
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's preview the selected animation right in the editor!",
		"In the [b]Animation List[/b] on the left, make sure that the [b]run[/b] animation is selected.",
		"Then, click the " + bbcode_generate_icon_image_by_name("Play") + "[b]Play[/b] button. Click it to play the animation.",
		"Notice how the frames play in sequence and loop. You can click the " + bbcode_generate_icon_image_by_name("Pause") + " [b]Pause[/b] button to pause the animation."
	])
	bubble_add_task_press_button(interface.spriteframes_frames_toolbar_play_button, "Play selected animation")
	complete_step()

	bubble_set_title("Run the scene")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	highlight_controls([interface.run_bar_play_current_button], true)
	scene_open("res://tours/101_animated_sprites_overview/101_in_game.tscn")
	bubble_add_text([
		"I just opened a game level for you to try and see the character in action.",
		"Click the [b]Run Current Scene[/b] button to play.",
		"Use the arrow keys to move the character and space to jump. Watch how the animations change based on what the character is doing! The character uses the animations defined in the SpriteFrames editor.",
		"When you're done exploring, close the game window to return to the editor.",
	])
	bubble_add_task_press_button(interface.run_bar_play_current_button)
	complete_step()

	bubble_set_title("Conclusion")
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_add_text([
		"That's a brief overview of the [b]AnimatedSprite2D[/b] node's editor interface and tools. You've seen the different parts of the [b]SpriteFrames[/b] editor:",
		"[ul]The [b]Animation List[/b] lets you create and rename animations\n" +
		"The [b]Frames View[/b] shows all frames in the current animation\n" +
		"The toolbars above the animation list and frames view let you edit animations and frames[/ul]",
		"In the next tour, you'll create an animation step-by-step. You'll learn how to create a new animation, add frames, and adjust the playback speed of your animations. See you there!"
	])
	complete_step()
