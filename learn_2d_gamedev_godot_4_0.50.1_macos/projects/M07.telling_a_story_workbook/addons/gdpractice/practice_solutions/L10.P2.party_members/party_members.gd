extends ColorRect

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var button_next: Button = %ButtonNext
@onready var button_previous: Button = %ButtonPrevious

var items: Array[Dictionary] = [
	{
		"name": "Dani", 
		"portrait": preload("./assets/character_dani.png")
	},
	{
		"name": "Gobot", 
		"portrait": preload("./assets/character_gdbot.png")
	},
	{
		"name": "Nova", 
		"portrait": preload("./assets/character_nova.png")
	},
]
var item_index := 0

func _ready() -> void:
	button_next.pressed.connect(advance)
	button_previous.pressed.connect(rewind)
	show_party_member()

# displays the party member's portrait and its name
func show_party_member() -> void:
	# make sure to display the member's image
	texture_rect.texture = items[item_index].portrait # 
	# make sure to display the member's name
	rich_text_label.text = items[item_index].name # pass

# Increments the index each time is called.
func advance() -> void:
	# make sure to increment the `item_index`
	item_index += 1 #
	if item_index >= items.size():
		item_index = 0
	# Don't forget to call the show_party_member function
	show_party_member() #

# Decrements the index each time is called.
func rewind() -> void:
	# make sure to decrement the `item_index`
	item_index -= 1 #
	if item_index < 0:
		item_index = items.size() - 1
	# Don't forget to call the show_party_member function
	show_party_member() #
