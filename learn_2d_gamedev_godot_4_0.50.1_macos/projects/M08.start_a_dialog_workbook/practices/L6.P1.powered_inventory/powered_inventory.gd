extends ColorRect

@onready var grid_container: GridContainer = %GridContainer
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var powerups_v_box_container: VBoxContainer = %PowerupsVBoxContainer

var tween: Tween

# Don't forget to add a few items to the list in the Inspector!
@export var items_list: Array[PoweredItem] = []


func _ready() -> void:
	for item in items_list:
		var button := InventorySlotButton.new()
		grid_container.add_child(button)
		# Warning! If your list has null values, you will get an error here.
		# Make sure your list doesn't have empty spots.
		button.text = item.text
		button.price = item.price
		button.pressed.connect(display_item.bind(button.text))
		button.pressed.connect(display_powerups.bind(item.powerups_list))


func display_powerups(powerups_list: Array[Power]) -> void:
	# Make sure to remove previous children before adding the new ones.
	# Once you removed all children, loop through the powerups_list array
	for power in powerups_list:
		# Create a TextureRect node.
		# Assign the power's image to the TextureRect node's `texture` property.
		# Then, add the TextureRect as a child of powerups_v_box_container.
		pass


# Displays an item. Requires an item name
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
