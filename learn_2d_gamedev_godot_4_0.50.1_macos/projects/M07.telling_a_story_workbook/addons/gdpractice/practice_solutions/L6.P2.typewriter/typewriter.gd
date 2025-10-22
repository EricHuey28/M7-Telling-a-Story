extends ColorRect

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

var lines := """
If you know
that 6 Hours of debugging
can save you 5 minutes
of reading documentation

If you try to automate
for 10 days
a task that needs 10 minutes

If you think, once again
that you can finish in 1 hour
a task that's always taken you 9

You'll be a gamedev, my student
"""
var appearance_time := 10.0

func _ready() -> void:
	rich_text_label.text = lines
	# Set the text's `visible_ratio` back to `0`
	rich_text_label.visible_ratio = 0 #
	# Make sure you animate the `visible_ratio` over `appearance_time`
	var tween := create_tween() #
	tween.tween_property(rich_text_label, "visible_ratio", 1, appearance_time) #
	# Start playing the sound
	audio_stream_player.play() #
	# And also remember to stop it!
	tween.finished.connect(audio_stream_player.stop) #
