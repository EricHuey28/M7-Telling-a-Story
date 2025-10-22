#ANCHOR:script_head
extends Control

#ANCHOR:dictionaries
var bodies := {
	"sophia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png")
}

var expressions := {
	"happy": preload("res://assets/emotion_happy.png"),
	"regular": preload("res://assets/emotion_regular.png"),
	"sad": preload("res://assets/emotion_sad.png"),
}
#END:dictionaries

@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression
#END:script_head
#ANCHOR:row_node_references
@onready var row_bodies: HBoxContainer = %RowBodies
@onready var row_expressions: HBoxContainer = %RowExpressions
#END:row_node_references


#ANCHOR:ready
func _ready() -> void:
	create_buttons()
#END:ready


#ANCHOR:button_pink_definition
func create_button_pink() -> void:
#END:button_pink_definition
#ANCHOR:button_pink_instance
	var button := Button.new()
	row_bodies.add_child(button)
#END:button_pink_instance

#ANCHOR:button_pink_text
	var key := "pink"
	button.text = key.capitalize()
#END:button_pink_text
#ANCHOR:button_pink_signal
	button.pressed.connect(func() -> void:
		body.texture = bodies[key]
	)
#END:button_pink_signal


#ANCHOR:create_buttons_definition
func create_buttons() -> void:
#END:create_buttons_definition
#ANCHOR:create_buttons_bodies
#ANCHOR:create_buttons_for_loop_bodies
	for current_body: String in bodies:
#END:create_buttons_for_loop_bodies
		var button := Button.new()
		row_bodies.add_child(button)
		button.text = current_body.capitalize()
		button.pressed.connect(func() -> void:
			body.texture = bodies[current_body]
		)
#END:create_buttons_bodies

#ANCHOR:create_buttons_expressions
	for current_expression: String in expressions:
		var button := Button.new()
		row_expressions.add_child(button)
		button.text = current_expression.capitalize()
		button.pressed.connect(func() -> void:
			expression.texture = expressions[current_expression]
		)
#END:create_buttons_expressions
