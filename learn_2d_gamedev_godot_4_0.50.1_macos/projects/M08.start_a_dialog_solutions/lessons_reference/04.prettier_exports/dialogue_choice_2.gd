#ANCHOR:part_1
## This resource represents a choice inside a dialogue item.
##
## DialogueChoice takes:[br]
## [br]
## - A text.[br]
## - A target dialogue line index to go to when picked.[br]
## - Optionally, [member is_quit] can be set to [code]true[/code].[br]
#ANCHOR:icon
@icon("res://assets/dialogue_choice_icon.svg")
#END:icon
#ANCHOR:class_name
#END:part_1
class_name DialogueChoice_step_2 extends Resource
#END:class_name

#ANCHOR:properties_without_class_name
## The choice button text. Can only use plain text (no BBCode)
@export var text := ""
## The target item to jump to next. This is the index of the dialogue item the
## choice leads to. It is ignored if [member is_quit] is set to [code]true[/code].
@export_range(0, 20) var target_line_idx := 0
## If set to [code]true[/code], this choice quits the dialogue and the
## [code]target_line_idx[/code] is ignored.
@export var is_quit := false
#END:properties_without_class_name
