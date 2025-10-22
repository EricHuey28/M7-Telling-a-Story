#ANCHOR:extends
extends CharacterBody2D
#END:extends

#ANCHOR:preloads_essentials
const RUNNER_DOWN = preload("res://assets/runner_down.png")
const RUNNER_DOWN_RIGHT = preload("res://assets/runner_down_right.png")
const RUNNER_RIGHT = preload("res://assets/runner_right.png")
const RUNNER_UP = preload("res://assets/runner_up.png")
const RUNNER_UP_RIGHT = preload("res://assets/runner_up_right.png")
#END:preloads_essentials
#ANCHOR:preloads_superfluous
const RUNNER_DOWN_LEFT = preload("res://assets/runner_down_left.png")
const RUNNER_LEFT = preload("res://assets/runner_left.png")
const RUNNER_UP_LEFT = preload("res://assets/runner_up_left.png")
#END:preloads_superfluous

#ANCHOR:const_directions
#ANCHOR:const_up_left
const UP_LEFT = Vector2.UP + Vector2.LEFT
#END:const_up_left
const UP_RIGHT = Vector2.UP + Vector2.RIGHT
#ANCHOR:const_down_left
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT
#END:const_down_left
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT
#END:const_directions

var max_speed := 600.0

#ANCHOR:node
@onready var _skin: Sprite2D = %Skin
#END:node

#ANCHOR:physics_process_definition
func _physics_process(_delta: float) -> void:
#END:physics_process_definition
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * max_speed
	move_and_slide()

#ANCHOR:direction_discrete
	var direction_discrete := direction.sign()
#END:direction_discrete
#ANCHOR:match_start
	match direction_discrete:
#END:match_start
#ANCHOR:match_first_two_cases
#ANCHOR:match_left_01
		Vector2.LEFT:
			_skin.texture = RUNNER_LEFT
#END:match_left_01
#ANCHOR:match_right
		Vector2.RIGHT:
#END:match_right
			_skin.texture = RUNNER_RIGHT
#END:match_first_two_cases
#ANCHOR:match_remaining_cases
		Vector2.UP:
			_skin.texture = RUNNER_UP
		Vector2.DOWN:
			_skin.texture = RUNNER_DOWN
#ANCHOR:match_left_02
		UP_LEFT:
			_skin.texture = RUNNER_UP_LEFT
#END:match_left_02
#ANCHOR:match_up_right
		UP_RIGHT:
#END:match_up_right
			_skin.texture = RUNNER_UP_RIGHT
#ANCHOR:match_left_03
		DOWN_LEFT:
			_skin.texture = RUNNER_DOWN_LEFT
#END:match_left_03
#ANCHOR:match_down_right
		DOWN_RIGHT:
#END:match_down_right
			_skin.texture = RUNNER_DOWN_RIGHT
#END:match_remaining_cases
