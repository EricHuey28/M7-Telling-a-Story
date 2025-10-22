extends "res://addons/godot_tours/tour.gd"

const TEXTURE_BUBBLE_BACKGROUND := preload("res://assets/bubble-background.png")
const TEXTURE_GDQUEST_LOGO := preload("res://assets/gdquest-logo.svg")
const TEXTURE_IDLE := preload("res://assets/lucy/idle/idle.png")
const TEXTURE_BLINKING := preload("res://assets/lucy/idle/blinking.png")

const CREDITS_FOOTER_GDQUEST := "[center]Godot Interactive Tours · Made by [url=https://www.gdquest.com/][b]GDQuest[/b][/url] · [url=https://github.com/GDQuest][b]Github page[/b][/url][/center]"

# Helper function to get the AnimatedSprite2D node created in this tour from the scene
func get_animated_sprite_node() -> AnimatedSprite2D:
	var scene_root = EditorInterface.get_edited_scene_root()
	return scene_root as AnimatedSprite2D

func _build() -> void:
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size("[center][b]Manipulating animation frames[/b][/center]", 32)])
	bubble_add_text([
		"[center]In this tour, you'll learn how to manipulate individual frames in the SpriteFrames editor.[/center]",
		"[center]You'll create an animation of a character blinking occasionally.[/center]",
	])
	bubble_set_footer(CREDITS_FOOTER_GDQUEST)
	queue_command(func wink_avatar(): bubble.avatar.do_wink())
	complete_step()

	bubble_set_title("Creating a new animation")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	highlight_controls([interface.spriteframes_animation_toolbar_add_animation_button], true)
	bubble_add_text([
		"It's common in games to have an idle animation with the character mostly standing still and blinking occasionally. That's what we'll create in this tour.",
		"Click the " + bbcode_generate_icon_image_by_name("New") + " [b]New Animation[/b] button at the top left of the editor."
	])
	bubble_add_task_press_button(interface.spriteframes_animation_toolbar_add_animation_button, "Add Animation")
	complete_step()

	bubble_set_title("Renaming the new animation")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.spriteframes_animations], true)
	bubble_add_text([
		"Animations are created with the default name [b]new_animation[/b]. This could be clearer so let's rename it.",
		"Click on [b]new_animation[/b] in the animation list to rename it. Type [b]idle[/b] and press Enter."
	])
	bubble_add_task(
		"Rename [b]new_animation[/b] to [b]idle[/b]",
		1,
		func(_task: Task) -> int:
			var animations_list := interface.spriteframes_animations
			var root := animations_list.get_root()
			if root == null:
				return 0

			for item in Utils.filter_tree_items(root, func(ti: TreeItem) -> bool: return true):
				if item.get_text(0) == "idle":
					return 1
			return 0
	)
	complete_step()

	bubble_set_title("The idle animation frames")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_filesystem_paths(["res://assets/lucy/idle/idle.png", "res://assets/lucy/idle/blinking.png"], true)
	bubble_add_text([
		"For the idle animation, we'll use two frames to make the character blink occasionally: one where the character is standing with open eyes and one where her eyes are closed.",
		"In the [b]FileSystem[/b] dock, find and select the idle animation images ([b]idle.png[/b] and [b]blinking.png[/b]). You can press the [b]Crtl[/b] key ([b]Cmd[/b] on macOS) before clicking to add a file to the selection."
	])
	bubble_add_task(
		"Select the [b]blinking.png[/b] and [b]idle.png[/b] files in the [b]FileSystem[/b] dock",
		2,
		func(_task: Task) -> int:
			var selected_paths = EditorInterface.get_selected_paths()
			var count := 0
			if selected_paths.has("res://assets/lucy/idle/idle.png"):
				count += 1
			if selected_paths.has("res://assets/lucy/idle/blinking.png"):
				count += 1
			return count
	)
	complete_step()

	bubble_set_title("Adding the idle frames")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_filesystem_paths(["res://assets/lucy/idle/idle.png", "res://assets/lucy/idle/blinking.png"], false)
	highlight_controls([interface.spriteframes_frames_list], false)
	bubble_add_text([
		"Drag and drop the selected idle images into the [b]Frames View[/b] of the SpriteFrames editor.",
		"You should end with two frames in the [b]Frames View[/b]: one for the standing pose and one for the blinking pose.",
	])
	bubble_add_task(
		"Add the standing and blinking frames to the animation.",
		1,
		func(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			if animated_sprite.sprite_frames.has_animation("idle") and animated_sprite.sprite_frames.get_frame_count("idle") == 2:
				var textures := [
					animated_sprite.sprite_frames.get_frame_texture("idle", 0),
					animated_sprite.sprite_frames.get_frame_texture("idle", 1)
				]
				if textures.has(TEXTURE_IDLE) and textures.has(TEXTURE_BLINKING):
					return 1
			return 0
	)
	mouse_click()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(interface.filesystem_tree, "res://assets/lucy/idle/idle.png"),
		get_control_global_center.bind(interface.spriteframes_frames_list)
	)
	mouse_click()
	complete_step()

	bubble_set_title("Reordering the frames")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	highlight_controls([interface.spriteframes_frames_list])
	bubble_add_text([
		"The frames were added based on their order in the [b]FileSystem[/b] dock: the blinking frame first, and the standing frame second.",
		"For our idle animation, we need to swap them: the standing pose should be frame [b]0[/b] (the first frame), and the blinking pose frame [b]1[/b] (the second frame).",
		"You can reorder the frames by dragging and dropping them within the [b]Frames View[/b].",
	])
	bubble_add_task(
		"Ensure the standing pose is frame [b]0[/b] and the blinking pose is frame [b]1[/b]",
		1,
		func(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			var frames_are_correct := (
				animated_sprite.sprite_frames.get_frame_count("idle") == 2 and
				animated_sprite.sprite_frames.get_frame_texture("idle", 0) == TEXTURE_IDLE and
				animated_sprite.sprite_frames.get_frame_texture("idle", 1) == TEXTURE_BLINKING
			)
			return 1 if frames_are_correct else 0
	)
	complete_step()

	bubble_set_title("Previewing the animation")
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.spriteframes_frames_toolbar_play_button], true)
	highlight_controls([interface.canvas_item_editor], false)
	bubble_add_text([
		"Good job! Now, click the " + bbcode_generate_icon_image_by_name("Play") + " [b]Play[/b] icon to preview the animation.",
		"As both frames have the same duration, the result looks off: the character blinks continuously.",
		"Instead, we want the character to only blink occasionally, so we need to adjust the timing of these frames."
	])
	bubble_add_task_press_button(
		interface.spriteframes_frames_toolbar_play_button,
		"Play the animation."
	)
	complete_step()

	bubble_set_title("Adjusting individual frame duration")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.spriteframes_frames_list])
	highlight_controls([interface.spriteframes_frames_toolbar_frame_duration], true)
	bubble_add_text([
		"We can adjust the duration of individual frames using the [b]Frame Duration[/b] field in the toolbar above the frames view.",
		"In the [b]Frames View[/b], select the frame [b]0[/b] (the standing pose).",
		"With the frame selected, head to the [b]Frame Duration[/b] field at the top right of the SpriteFrames editor.",
		"Change the value from [b]1.0[/b] to [b]20.0[/b] and press [b]Enter[/b]. This makes this frame stay on screen 20 times longer than the default duration."
	])
	bubble_add_task(
		"Change the [b]Frame Duration[/b] of the frame [b]0[/b] to [b]20.0[/b]",
		1,
		func(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			if (
				is_equal_approx(animated_sprite.sprite_frames.get_frame_duration("idle", 0), 20.0) and
				is_equal_approx(animated_sprite.sprite_frames.get_frame_duration("idle", 1), 1.0)
			):
				return 1
			return 0
	)
	complete_step()

	bubble_set_title("Previewing the adjusted animation")
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.canvas_item_editor], false)
	highlight_controls([interface.spriteframes_frames_toolbar_play_button], true)
	bubble_add_text([
		"Click the " + bbcode_generate_icon_image_by_name("Play") + " [b]Play[/b] button again to preview the animation with the adjusted timing.",
		"Now the character stays in the standing pose for much longer and only blinks occasionally. This is more natural!"
	])
	bubble_add_task_press_button(
		interface.spriteframes_frames_toolbar_play_button,
		"Play the animation."
	)
	complete_step()

	bubble_set_title("Creating a blinking pattern")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.spriteframes_frames_list])
	bubble_add_text([
		"Now let's make the character blink twice in a row before returning to the long idle pose. It'll make the animation nicer and it'll teach you how to copy and paste frames.",
		"First, we have to select the frames we want to copy.",
		"Click on the first frame, then hold [b]Shift[/b] and click on the second frame to select both frames."
	])
	bubble_add_task(
		"Select both animation frames",
		1,
		func(_task: Task) -> int:
			if interface.spriteframes_frames_list.get_selected_items().size() >= 2:
				return 1
			return 0
	)
	complete_step()

	bubble_set_title("Pasting frames")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.spriteframes_frames_list], false)
	highlight_controls([interface.spriteframes_frames_toolbar_copy_button], true)
	bubble_add_text([
		"With both frames selected, click the " + bbcode_generate_icon_image_by_name("ActionCopy") + " [b]Copy Frames[/b] button above the [b]Frames View[/b] to copy the frames in the clipboard."
	])
	bubble_add_task_press_button(interface.spriteframes_frames_toolbar_copy_button, "Copy Frames")
	complete_step()

	bubble_set_title("Pasting frames")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.spriteframes_frames_list], false)
	highlight_controls([interface.spriteframes_frames_toolbar_paste_button], true)
	bubble_add_text([
		"Now click the " + bbcode_generate_icon_image_by_name("ActionPaste") + " [b]Paste Frames[/b] button. This duplicates the copied frames and inserts them at the end of the animation."
	])
	bubble_add_task_press_button(interface.spriteframes_frames_toolbar_paste_button, "Paste Frames")
	complete_step()

	bubble_set_title("The updated animation")
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.canvas_item_editor], false)
	highlight_controls([interface.spriteframes_frames_toolbar_play_button], true)
	bubble_add_text([
		"Click the " + bbcode_generate_icon_image_by_name("Play") + " [b]Play[/b] button to preview the animation.",
		"Copying and pasting the frames duplicated our animation. The character waits for a long time, blinks, and repeats the pattern.",
		"We can adjust the third frame's duration to make the character blink twice in a row.",
	])
	complete_step()

	bubble_set_title("Changing the second idle pose duration")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.spriteframes_frames_list], false)
	highlight_controls([interface.spriteframes_frames_toolbar_frame_duration], false)
	bubble_add_text([
		"Click on frame [b]2[/b] (the second standing pose) to select it. Then, change the [b]Frame Duration[/b] from [b]20.0[/b] to [b]2.0[/b].",
		"This will result in a much shorter idle pose and make the character blink twice in a row before returning to the long idle pose."
	])
	bubble_add_task(
		"Change the [b]Frame Duration[/b] of frame [b]2[/b] to [b]2.0[/b]",
		1,
		func(_task: Task) -> int:
			if interface.spriteframes_frames_list.is_anything_selected() and is_equal_approx(interface.spriteframes_frames_toolbar_frame_duration.value, 2.0):
				return 1
			return 0
	)
	complete_step()

	bubble_set_title("Previewing the idle animation")
	bubble_move_and_anchor(interface.base_control, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_controls([interface.canvas_item_editor], false)
	highlight_controls([interface.spriteframes_frames_toolbar_play_button], false)
	bubble_add_text([
		"Click the [b]Play[/b] button to preview the idle animation with the adjusted timing.",
		"It looks much nicer, doesn't it?",
	])
	bubble_add_task_press_button(interface.spriteframes_frames_toolbar_play_button, "Play")
	complete_step()

	bubble_set_title("Reviewing what we've done")
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"Let's review how we created the idle animation:",
		"[ul]Frame [b]0[/b] (the standing pose) lasts 20 frames\n" +
		"Frame [b]1[/b] (the first blink) shows briefly for one frame\n" +
		"Frame [b]2[/b] (standing pose again) lasts 2 frames\n" +
		"Frame [b]3[/b] (blinking again) shows briefly for one frame before the cycle repeats[/ul]",
		"All it took was 2 textures! By reordering the frames and adjusting their durations, you could create a nice idle animation.",
	])
	complete_step()

	bubble_set_title("Congratulations!")
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"You've successfully learned how to use the [b]AnimatedSprite2D[/b] node and [b]SpriteFrames[/b] editor to create frame-by-frame animations!",
		"In this tour, you've learned how to:",
		"[ul]Modify individual frame durations\n" +
		"Drag and drop frames in the [b]Frames View[/b] to reorder them\n" +
		"Copy and paste frames to duplicate them[/ul]",
		"Between the previous tour and this one, you learned the features you'll use most often in the [b]SpriteFrames[/b] editor!",
		"After completing this tour, you can keep experimenting and return to GDSchool to continue with this module's lessons whenever you want.",
	])
	complete_step()
