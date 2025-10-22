#ANCHOR:part_1
#ANCHOR:class_name
@tool
#ANCHOR:icon
@icon("res://assets/dialogue_scene_icon.svg")
#END:icon
extends Control
#END:class_name

#ANCHOR:010_the_dialog_array
## An array of dialogue items
#END:part_1
@export var dialogue_items: Array[DialogueItem_step_2] = []:
#ANCHOR:part_2
	set = set_dialogue_items
#END:010_the_dialog_array

#ANCHOR:onreadies
## UI element that shows the texts
@onready var rich_text_label: RichTextLabel = %RichTextLabel
## Audio player that plays voice sounds while text is being written
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
## The character
@onready var body: TextureRect = %Body
## The Expression
@onready var expression: TextureRect = %Expression
## The container for buttons
@onready var action_buttons_v_box_container: VBoxContainer = %ActionButtonsVBoxContainer
#END:onreadies

func _ready() -> void:
#ANCHOR:editor_hint
	if Engine.is_editor_hint():
		return
#END:editor_hint
#ANCHOR:show_text_call
	show_text(0)
#END:show_text_call

#ANCHOR:full_file
## Draws the selected text
## [param current_item_index] Displays the currently selected index from the dialogue array
func show_text(current_item_index: int) -> void:
	# We retrieve the current item from the array
#ANCHOR:020_type_variable
	var current_item := dialogue_items[current_item_index]
#END:020_type_variable
	# We set the initial visible ratio to the text to 0, so we can change it in the tween
	rich_text_label.visible_ratio = 0.0
	# from the item, we extract the properties.
	# We set the text to the rich text control
	# And we set the appropriate expression texture
#ANCHOR:set_properties
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	body.texture = current_item.character
	create_buttons(current_item.choices)
#END:set_properties
	# We create a tween that will draw the text
	var tween := create_tween()
	# A variable that holds the amount of time for the text to show, in seconds
	# We could write this directly in the tween call, but this is clearer.
	# We will also use this for deciding on the sound length
	var text_appearing_duration := (current_item["text"] as String).length() / 30.0
	# We show the text slowly
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	# We randomize the audio playback's start time to make it sound different
	# every time.
	# We obtain the last possible offset in the sound that we can start from
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	# We pick a random position on that length
	var sound_start_position := randf() * sound_max_offset
	# We start playing the sound
	audio_stream_player.play(sound_start_position)
	# We make sure the sound stops when the text finishes displaying
	tween.finished.connect(audio_stream_player.stop)
	slide_in()


#ANCHOR:create_button_complete
## Adds buttons to the buttons container
## [param buttons_data] An array of [DialogChoice]
#ANCHOR:create_buttons_signature
#END:part_2
func create_buttons(buttons_data: Array[DialogueChoice_step_2]) -> void:
#ANCHOR:part_3
#END:create_buttons_signature
#ANCHOR:remove_previous_nodes
	for button in action_buttons_v_box_container.get_children():
		button.queue_free()
#END:remove_previous_nodes
#ANCHOR:loop_start
	for choice in buttons_data:
#END:loop_start
#ANCHOR:create_button
		var button := Button.new()
		button.size_flags_horizontal = Control.SIZE_SHRINK_END
		action_buttons_v_box_container.add_child(button)
#END:create_button
#ANCHOR:extract_choice_destination
		button.text = choice.text
		if choice.is_quit:
			button.pressed.connect(get_tree().quit)
		else:
			var target_line_id := choice.target_line_idx
			button.pressed.connect(show_text.bind(target_line_id))
#END:extract_choice_destination
#END:create_button_complete

## Animates the character when they start talking
func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
#END:full_file

#ANCHOR:editor_warning
func _get_configuration_warnings() -> PackedStringArray:
	if dialogue_items.is_empty():
		return ["You need at least one dialogue item for the dialogue system to work."]
	return []
#END:editor_warning

## Setter for the [param dialogue_items] property. Ensures the dialogue items array
## never has an empty element.
#ANCHOR:handle_array
#END:part_3
func set_dialogue_items(new_dialog_items: Array[DialogueItem_step_2]) -> void:
	for index in new_dialog_items.size():
		if new_dialog_items[index] == null:
			new_dialog_items[index] = DialogueItem_step_2.new()
	dialogue_items = new_dialog_items
#END:handle_array
#ANCHOR:update_warning
	update_configuration_warnings()
#END:update_warning
