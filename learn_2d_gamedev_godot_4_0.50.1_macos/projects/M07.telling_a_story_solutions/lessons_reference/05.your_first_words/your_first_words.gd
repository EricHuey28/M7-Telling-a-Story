#ANCHOR:010_extends
extends Control
#END:010_extends

#ANCHOR:020_the_dialogue_array
## An array of strings. Each string contains the text we want the character to
## say.
#ANCHOR:the_dialogue_array_declaration
var dialogue_items: Array[String] = [
#END:the_dialogue_array_declaration
#ANCHOR:010_first_array_item
	"I'm learning about Arrays...",
#END:010_first_array_item
	"...and it is a little bit complicated.",
	"Let's see if I got it right: an array is a list of values!",
	"Did I get it right? Did I?",
	"Hehe! Bye bye~!",
]
#END:020_the_dialogue_array
#ANCHOR:030_item_index
## Holds the index of the currently displayed text
#ANCHOR:only_item_index
var current_item_index := 0
#END:only_item_index
#END:030_item_index

#ANCHOR:020_nodes
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
#END:020_nodes
#ANCHOR:node_audio
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
#END:node_audio


func _ready() -> void:
#ANCHOR:060_show_text
	show_text()
#END:060_show_text
#ANCHOR:080_connect_advance
	next_button.pressed.connect(advance)
#END:080_connect_advance

#ANCHOR:200_show_text
#ANCHOR:095_show_text_part_1
## Draws the current text to the rich text element
#ANCHOR:show_text_definition
func show_text() -> void:
#END:show_text_definition
#ANCHOR:050_select_text
	var current_item := dialogue_items[current_item_index]
#END:050_select_text
#ANCHOR:055_assign_text
	rich_text_label.text = current_item
#END:095_show_text_part_1
#END:055_assign_text
	# We animate the text appearing letter by letter.
#ANCHOR:160_tween_text
#ANCHOR:110_visible_ratio
	rich_text_label.visible_ratio = 0.0
#END:110_visible_ratio
#ANCHOR:120_new_tween
	var tween := create_tween()
#END:120_new_tween
#ANCHOR:130_duration
	var text_appearing_duration := 1.2
#END:130_duration
#ANCHOR:140_tween_property
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
#END:140_tween_property
#END:160_tween_text
	# This is where we play the audio. We randomize the audio playback's start
	# time to make it sound different every time.
#ANCHOR:170_max_length
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
#END:170_max_length
#ANCHOR:180_start_pos
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
#END:180_start_pos
	# We stop the audio when the text finishes appearing.
#ANCHOR:190_stop_sound
	tween.finished.connect(audio_stream_player.stop)
#END:190_stop_sound
#END:200_show_text

#ANCHOR:100_advance_function_content
#ANCHOR:advance_definition
#ANCHOR:070_advance_function_definition
func advance() -> void:
#END:advance_definition
	current_item_index += 1
#END:070_advance_function_definition
	# If we reached the end of the dialogue, we quit the game. Otherwise, we
	# show the next dialogue line.
#ANCHOR:advance_check_current_item
	if current_item_index == dialogue_items.size():
		get_tree().quit()
#END:advance_check_current_item
#ANCHOR:advance_else_branch
	else:
		show_text()
#END:advance_else_branch
#END:100_advance_function_content
