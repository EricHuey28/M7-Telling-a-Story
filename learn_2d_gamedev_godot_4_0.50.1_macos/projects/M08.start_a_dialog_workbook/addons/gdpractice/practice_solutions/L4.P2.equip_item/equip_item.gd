extends ColorRect

@onready var grid_container: GridContainer = %GridContainer
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

var tween: Tween

var items_list := {
	"sword": 1,
	"shield": 1,
	"coin": 30,
	"potion": 2,
	"key": 1,
	"gem": 5,
	"compass": 1,
	"torch": 3,
	"book": 1,
	"shrimp": 42,
	"scroll": 2,
	"ring": 2,
}


func _ready() -> void:
	display_item("purse")
	for item_name in items_list:
		var button := InventorySlotButton.new()
		button.text = item_name
		grid_container.add_child(button)
		# Connect the button here. Don't forget to use .bind()!
		button.pressed.connect(display_item.bind(item_name)) #


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
