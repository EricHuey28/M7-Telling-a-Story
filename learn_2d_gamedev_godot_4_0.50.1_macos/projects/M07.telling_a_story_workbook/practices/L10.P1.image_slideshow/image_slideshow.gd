extends ColorRect

var items: Array[Texture] = [
	preload("./assets/character_dani.png"),
	preload("./assets/character_gdbot.png"),
	preload("./assets/character_nova.png")
]
var item_index := 0

@onready var texture_rect: TextureRect = %TextureRect
@onready var button: Button = %Button


func _ready() -> void:
	button.pressed.connect(advance)
	show_image()


# Displays the image
func show_image() -> void:
	pass


# Increments the index each time is called.
func advance() -> void:
	# make sure to increment the `item_index`
	if item_index >= items.size():
		item_index = 0
	# Don't forget to call the show_image function
