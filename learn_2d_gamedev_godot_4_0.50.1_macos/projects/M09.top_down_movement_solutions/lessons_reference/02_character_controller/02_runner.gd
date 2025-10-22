extends CharacterBody2D

const RUNNER_DOWN = preload("res://assets/runner_down.png")
const RUNNER_DOWN_RIGHT = preload("res://assets/runner_down_right.png")
const RUNNER_RIGHT = preload("res://assets/runner_right.png")
const RUNNER_UP = preload("res://assets/runner_up.png")
const RUNNER_UP_RIGHT = preload("res://assets/runner_up_right.png")

const UP_RIGHT = Vector2.UP + Vector2.RIGHT
const UP_LEFT = Vector2.UP + Vector2.LEFT
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT

#ANCHOR:max_speed
var max_speed := 600.0
#END:max_speed

@onready var _skin: Sprite2D = %Skin


#ANCHOR:physics_process_definition
func _physics_process(_delta: float) -> void:
#END:physics_process_definition
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
#ANCHOR:movement
	velocity = direction * max_speed
#END:movement
	move_and_slide()

	var direction_discrete := direction.sign()
#ANCHOR:match
	match direction_discrete:
#END:match
#ANCHOR:match_right
		Vector2.RIGHT, Vector2.LEFT:
#END:match_right
			_skin.texture = RUNNER_RIGHT
		Vector2.UP:
			_skin.texture = RUNNER_UP
		Vector2.DOWN:
			_skin.texture = RUNNER_DOWN
#ANCHOR:match_up_right
		UP_RIGHT, UP_LEFT:
#END:match_up_right
			_skin.texture = RUNNER_UP_RIGHT
#ANCHOR:match_down_right
		DOWN_RIGHT, DOWN_LEFT:
#END:match_down_right
			_skin.texture = RUNNER_DOWN_RIGHT

#ANCHOR:flip_h
	if direction_discrete.length() > 0:
		_skin.flip_h = direction.x < 0.0
#END:flip_h
