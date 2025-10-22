#ANCHOR:full_file_part_1
extends Control

#END:full_file_part_1
#ANCHOR:010_the_dialog_array
## An array of slideshow entries
@export var dialogue_items: Array[SlideShowEntry_step_1] = []
#END:010_the_dialog_array
#ANCHOR:full_file_part_2
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
#ANCHOR:020_assigning_the_values
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	body.texture = current_item.character
#END:020_assigning_the_values
	# We set the initial visible ratio to the text to 0, so we can change it in the tween
	rich_text_label.visible_ratio = 0.0
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
#END:full_file_part_2
