@tool
extends "res://addons/gdpractice/metadata.gd"

func _init() -> void:
	list += [
		PracticeMetadata.new(
			"03_interesting_choices_01_populate_inventory",
			"Fill the Inventory",
			preload("L4.P1.populate_inventory/populate_inventory.tscn")
		),
		PracticeMetadata.new(
			"03_interesting_choices_02_function_bind",
			"Equipping an Item",
			preload("L4.P2.equip_item/equip_item.tscn")
		),
		PracticeMetadata.new(
			"04_stronger_guarantees_01_dict_to_resource",
			"Shopping for Items",
			preload("L5.P1.shopping_loot/shopping_loot.tscn")
		),
		PracticeMetadata.new(
			"05_stronger_choices_01_powerups",
			"Powered up items",
			preload("res://addons/gdpractice/practice_solutions/L6.P1.powered_inventory/powered_inventory.tscn")
		),
	]
