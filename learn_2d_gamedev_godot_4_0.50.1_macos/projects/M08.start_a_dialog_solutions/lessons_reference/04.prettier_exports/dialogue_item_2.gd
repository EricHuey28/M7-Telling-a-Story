#ANCHOR:part_1
@tool
#ANCHOR:icon
@icon("res://assets/dialogue_item_icon.svg")
#END:icon
#END:part_1
#ANCHOR:class_name
class_name DialogueItem_step_2 extends SlideShowEntry_step_2
#END:class_name
#ANCHOR:part_2

@export_group("Choices")
## An array of choices. Each choice will become a button in the interface
#ANCHOR:choices
@export var choices: Array[DialogueChoice_step_2] = []: set = set_choices
#END:choices

## Setter for the [param choices] property. Ensures the choices array never has 
## an empty element.
func set_choices(new_choices: Array[DialogueChoice_step_2]) -> void:
	for index in new_choices.size():
		if new_choices[index] == null:
			new_choices[index] = DialogueChoice_step_2.new()
	choices = new_choices
#END:part_2
