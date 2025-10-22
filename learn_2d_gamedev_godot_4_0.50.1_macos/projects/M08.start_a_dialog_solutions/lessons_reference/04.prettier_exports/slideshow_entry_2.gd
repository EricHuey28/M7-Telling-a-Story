#ANCHOR:class_name
class_name SlideShowEntry_step_2 extends Resource
#END:class_name
#ANCHOR:properties_without_class_name

#ANCHOR:group_name_images
@export_group("Images")
#END:group_name_images
## Represents the character's expression for this dialogue bubble
#ANCHOR:property_expression
@export var expression := preload("res://assets/emotion_regular.png")
#END:property_expression
## Represents the character's body for this dialogue bubble
#ANCHOR:property_character
@export var character := preload("res://assets/sophia.png")
#END:property_character

#ANCHOR:group_name_text
@export_group("Text")
#END:group_name_text
## The text of this dialogue bubble
#ANCHOR:property_text
@export_multiline var text := ""
#END:property_text
#END:properties_without_class_name
