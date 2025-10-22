#ANCHOR:l12_01
extends Control

var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}

#ANCHOR:010_bodies_resources
var bodies := {
	"sophia": preload ("res://assets/sophia.png"),
	"pink": preload ("res://assets/pink.png")
}
#END:010_bodies_resources

#ANCHOR:030_the_dialog_array
## Data to display in the dialogue. Each dictionary in this array has three properties:
##
## - expression: a [code]Texture[/code] containing an expression
## - text: a [code]String[/code] containing the text the character says
## - character: a [code]Texture[/code] representing the character
#ANCHOR:dialogue_items_definition
var dialogue_items: Array[Dictionary] = [
#END:dialogue_items_definition
#ANCHOR:020_dialogue_item_example
	{
		"expression": expressions["regular"],
#ANCHOR:will_change_010
		"text": "I've been studying arrays and dictionaries lately.",
#END:will_change_010
		"character": bodies["sophia"],
	},
#END:020_dialogue_item_example
	{
		"expression": expressions["regular"],
		"text": "Oh, nice. How has it been going?",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["sad"],
#ANCHOR:will_change_020
		"text": "Well... it's a little complicated!",
#END:will_change_020
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["sad"],
		"text": "Oh!",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "It sure takes time to click at first.",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["happy"],
		"text": "If you keep at it, eventually, you'll get the hang of it!",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "Mhhh... I see. I'll keep at it, then.",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["happy"],
#ANCHOR:will_change_030
		"text": "Thanks for the encouragement. Time to LEARN!!!",
#END:will_change_030
		"character": bodies["sophia"],
	},
]
#END:030_the_dialog_array
var current_item_index := 0


@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression


func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)


#ANCHOR: show_text_definition
func show_text() -> void:
	# We first extract data for the current dialogue item and apply it to the UI
	# elements.
#END: show_text_definition
	var current_item := dialogue_items[current_item_index]
#ANCHOR:040_previous
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
#END:040_previous
#ANCHOR:050_get_body_texture
	body.texture = current_item["character"]
#END:050_get_body_texture

	# We then hide the text and animate it appearing.
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
#ANCHOR:060_duration
	var text_appearing_duration: float = current_item["text"].length() / 30.0
#END:060_duration
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)

	# We randomize the audio playback's start time to make it sound different
	# every time and play the sound until the text finishes displaying.
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)

	# We animate the character sliding in.
	slide_in()
#END:l12_01

	# Finally, we disable the next button until the text finishes displaying.
#ANCHOR:070_disable_next_button
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
	)
#END:070_disable_next_button


#ANCHOR:l12_02
## Advances the dialogue to the next item or quits the game if there are no more
## items.
func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()


## Animates the character sliding in.
func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = 200
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
#END:l12_02
