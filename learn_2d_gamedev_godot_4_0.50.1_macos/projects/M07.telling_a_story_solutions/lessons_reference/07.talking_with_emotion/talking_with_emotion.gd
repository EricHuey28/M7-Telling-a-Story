#ANCHOR:l10_01
extends Control

#ANCHOR:020_preload_images
var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}
#END:020_preload_images

## An array of dictionaries. Each dictionary has two properties:
## - expression: a [code]Texture[/code] containing an expression
## - text: a [code]String[/code] containing the text the character says
#ANCHOR:040_the_dialog_array
#ANCHOR:the_dialogue_array_declaration
var dialogue_items: Array[Dictionary] = [
#END:the_dialogue_array_declaration
#ANCHOR:030_first_array_item
	{
		"expression": expressions["regular"],
		"text": "I'm learning about Arrays...",
	},
#END:030_first_array_item
	{
		"expression": expressions["sad"],
		"text": "... and it is a little bit complicated.",
	},
	{
		"expression": expressions["happy"],
		"text": "Let's see if I got it right: an array is a list of values!",
	},
	{
		"expression": expressions["regular"],
		"text": "Did I get it right? Did I?",
	},
	{
		"expression": expressions["happy"],
		"text": "Hehe! Bye bye~!",
	},
]
#END:040_the_dialog_array
var current_item_index := 0

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
#ANCHOR:010_new_nodes
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression
#END:010_new_nodes


func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)


#ANCHOR:110_show_text_updated
## Draws the current text to the rich text element
#ANCHOR:show_text_definition
func show_text() -> void:
#END:show_text_definition
	# We retrieve the current dictionary from the array and assign its
	# properties to the UI elements.
	var current_item := dialogue_items[current_item_index]
#ANCHOR:050_set_properties
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
#END:050_set_properties
	# We animate the text appearing letter by letter.
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
#ANCHOR:120_duration
	var text_appearing_duration := 1.0
#END:120_duration
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)

	# This is where we play the audio. We randomize the audio playback's start
	# time to make it sound different every time.
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	# We stop the audio when the text finishes appearing.
	tween.finished.connect(audio_stream_player.stop)
#END:l10_01

#ANCHOR:100_call_slide_in
	slide_in()
#END:100_call_slide_in
#END:110_show_text_updated


#ANCHOR:l10_02
func advance() -> void:
	current_item_index += 1
	# If we reached the end of the dialogue, we quit the game. Otherwise, we
	# show the next dialogue line.
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()
#END:l10_02


#ANCHOR:slide_in_definition
func slide_in() -> void:
#END:slide_in_definition
#ANCHOR:060_create_tween
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
#END:060_create_tween
#ANCHOR:070_animate_position
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.3)
#END:070_animate_position
#ANCHOR:080_animate_alpha
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.2)
#END:080_animate_alpha
