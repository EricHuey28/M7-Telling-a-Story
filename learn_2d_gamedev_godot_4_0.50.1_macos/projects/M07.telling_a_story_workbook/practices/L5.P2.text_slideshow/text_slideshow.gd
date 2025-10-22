extends ColorRect

var items: Array[String] = [
	"Strings. Ints. Floats. Nulls.",
	"Long ago, the four types lived together in harmony.",
	"Then, everything changed when the typed Array arrived.",
	"Only the Programmer, student of all types, could stop them.",
	"But when the world needed them most, they were studying on GDQuest.",
]
var item_index := 0

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var button: Button = %Button


func _ready() -> void:
	button.pressed.connect(advance)
	show_text()


func show_text() -> void:
	# Make sure to display the text
	pass


# Increments the index each time is called.
func advance() -> void:
	# make sure to increment the `item_index`
	if item_index >= items.size():
		item_index = 0
	# Don't forget to call the show_text function
