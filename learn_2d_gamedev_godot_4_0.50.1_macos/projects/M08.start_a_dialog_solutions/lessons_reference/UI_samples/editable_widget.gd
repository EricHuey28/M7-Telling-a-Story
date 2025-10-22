@tool
extends HBoxContainer

@onready var _label: Label = %Label

## Title of the item. Gets assigned to the underlying label
@export var title := "": set = set_title

## [param title] property setter.
func set_title(new_title: String) -> void:
	title = new_title
	if not is_inside_tree():
		await ready
	_label.text = title
