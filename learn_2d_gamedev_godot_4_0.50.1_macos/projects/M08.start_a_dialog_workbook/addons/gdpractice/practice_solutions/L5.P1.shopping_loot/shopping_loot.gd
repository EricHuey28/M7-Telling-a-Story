extends ColorRect

@onready var grid_container: GridContainer = %GridContainer
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

var tween: Tween

# Don't forget to add a few items from the editor!
@export var items_list: Array[ShoppingEntryPractice] = [] # @export var items_list: Array[ShoppingEntry] = []

func _ready() -> void:
	display_item("purse")
	for item in items_list:
		var button := InventorySlotButton.new()
		grid_container.add_child(button)
		# Set the button's properties: text, amount, and price from the item.
		# Warning! You will get an error here if you didn't set up the
		# ShoppingEntry resource before.
		button.text = item.text #
		button.amount = item.amount #
		button.price = item.price #
		button.pressed.connect(display_item.bind(button.text))


# Displays an item. The text parameter is the name of the item.
func display_item(text: String) -> void:
	texture_rect.texture = PracticeIcons.get_texture(text)
	label.text = text
	if tween != null && tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	texture_rect.position.y = 100
	tween.tween_property(texture_rect, "position:y", 0.0, .7)
	texture_rect.modulate.a = 0
	tween.tween_property(texture_rect, "modulate:a", 1.0, .9)
	label.modulate.a = 0
	tween.tween_property(label, "modulate:a", 1.0, 1)
