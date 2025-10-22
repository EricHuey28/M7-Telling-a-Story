extends Control

var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}

var bodies := {
	"sophia": preload ("res://assets/sophia.png"),
	"pink": preload ("res://assets/pink.png")
}

## An array of dictionaries. Each dictionary has three properties:
## - expression: a [code]Texture[/code] containing an expression
## - text: a [code]String[/code] containing the text the character says
## - character: a [code]Texture[/code] representing the character
var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "I've been learning about [wave]Arrays and Dictionaries[/wave]",
		"character": bodies["sophia"]
	},
	{
		"expression": expressions["regular"],
		"text": "How has it been going?",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["sad"],
		"text": "... Well... it is a little bit [shake]complicated[/shake]!",
		"character": bodies["sophia"]
	},
	{
		"expression": expressions["sad"],
		"text": "Oh!",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["regular"],
		"text": "I believe in you!",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["happy"],
		"text": "If you stick to it, you'll eventually make it!",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["happy"],
		"text": "That's it! Let's [tornado freq=3.0][rainbow val=1.0]GOOOOOO!!![/rainbow][/tornado]",
		"character": bodies["sophia"]
	}
]
var current_item_index := 0

## UI element that shows the texts
@onready var rich_text_label: RichTextLabel = %RichTextLabel
## UI element that progresses to the next text
@onready var next_button: Button = %NextButton
## Audio player that plays voice sounds while text is being written
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
## The character
@onready var body: TextureRect = %Body
## The Expression
@onready var expression: TextureRect = %Expression


func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)


## Draws the current text to the rich text element
func show_text() -> void:
	# We retrieve the current item from the array
	var current_item := dialogue_items[current_item_index]
	# from the item, we extract the properties.
	# We set the text to the rich text control
	# And we set the appropriate expression texture
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	body.texture = current_item["character"]

	# We set the initial visible ratio to the text to 0, so we can change it in the tween
	rich_text_label.visible_ratio = 0.0
	# We create a tween that will draw the text
	var tween := create_tween()
	# A variable that holds the amount of time for the text to show, in seconds
	# We could write this directly in the tween call, but this is clearer.
	# We will also use this for deciding on the sound length
	var text_appearing_duration: float = current_item["text"].length() / 30.0
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

	# We animate the character sliding in.
	slide_in()

	# Finally, we disable the next button until the text finishes displaying.
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
	)


## Progresses to the next slide.
func advance() -> void:
	# We increment the slide amount by 1
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		# if we reached the last slide, quit
		get_tree().quit()
	else:
		# otherwise, show the text
		show_text()


## Animates the character when they start talking
func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
