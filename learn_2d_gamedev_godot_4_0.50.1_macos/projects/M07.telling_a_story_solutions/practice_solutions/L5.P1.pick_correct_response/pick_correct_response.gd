extends ColorRect

var items: Array[String] = [
	"They prefer binary trees.",
	"There's no Wi-Fi signal in the forest.",
	"It has too many bugs!",
	"They can't Ctrl+S a sunset.",
	"Nature doesn't have a code review process.",
]
# change this to point at the correct item: "It has too many bugs!"
var item_index := 2 # var item_index := 0

@onready var response_label: Label = %responseLabel


func _ready() -> void:
	show_text()


func show_text() -> void:
	response_label.text = items[item_index]
