extends Control

#ANCHOR:020_bodies_preload
var bodies := {
	"sophia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png")
}
#END:020_bodies_preload

#ANCHOR:030_expressions_preload
var expressions := {
	"happy": preload("res://assets/emotion_happy.png"),
	"regular": preload("res://assets/emotion_regular.png"),
	"sad": preload("res://assets/emotion_sad.png"),
}
#END:030_expressions_preload

#ANCHOR:010_reference_nodes
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression
@onready var button_sophia: Button = %ButtonSophia
@onready var button_pink: Button = %ButtonPink
@onready var button_regular: Button = %ButtonRegular
@onready var button_sad: Button = %ButtonSad
@onready var button_happy: Button = %ButtonHappy
#END:010_reference_nodes


#ANCHOR:040_test_dictionaries
func _ready() -> void:
	body.texture = bodies["pink"]
	expression.texture = expressions["happy"]
#END:040_test_dictionaries

#ANCHOR:060_connections
#ANCHOR:050_button_sophia
	button_sophia.pressed.connect(func() -> void:
		body.texture = bodies["sophia"]
	)
#END:050_button_sophia
	button_pink.pressed.connect(func() -> void:
		body.texture = bodies["pink"]
	)
	button_regular.pressed.connect(func() -> void:
		expression.texture = expressions["regular"]
	)
	button_sad.pressed.connect(func() -> void:
		expression.texture = expressions["sad"]
	)
	button_happy.pressed.connect(func() -> void:
		expression.texture = expressions["happy"]
	)
#END:060_connections
