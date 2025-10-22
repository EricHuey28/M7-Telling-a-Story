class_name PoweredItemPractice extends Resource # class_name PoweredItem extends Resource 

@export var text := ""
@export var price := 10
# Modify the line below. Currently it is a regular array.
# Instead, '@export' an array of `Power` resources
@export var powerups_list: Array[PowerPractice] = [] # var powerups_list = []
