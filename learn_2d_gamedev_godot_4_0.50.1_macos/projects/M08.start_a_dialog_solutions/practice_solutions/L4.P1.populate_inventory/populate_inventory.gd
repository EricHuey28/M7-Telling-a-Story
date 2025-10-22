extends ColorRect

@onready var grid_container: GridContainer = %GridContainer

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
	for item_name in items_list:
		var button := InventorySlotButton.new()
		# Assign the item's name and amount to the button properties.
		# Don't forget to add the button to the grid container.
		button.text = item_name #
		button.amount = items_list[item_name] #
		grid_container.add_child(button) #
