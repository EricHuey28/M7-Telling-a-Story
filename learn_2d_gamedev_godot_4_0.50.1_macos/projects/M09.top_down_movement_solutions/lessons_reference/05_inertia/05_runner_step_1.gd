#ANCHOR:extends
extends CharacterBody2D
#END:extends

#ANCHOR:consts
const RUNNER_DOWN = preload("res://assets/runner_down.png")
const RUNNER_DOWN_RIGHT = preload("res://assets/runner_down_right.png")
const RUNNER_RIGHT = preload("res://assets/runner_right.png")
const RUNNER_UP = preload("res://assets/runner_up.png")
const RUNNER_UP_RIGHT = preload("res://assets/runner_up_right.png")

const UP_RIGHT = Vector2.UP + Vector2.RIGHT
const UP_LEFT = Vector2.UP + Vector2.LEFT
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT
#END:consts

#ANCHOR:max_speed
## The top speed that the runner can achieve.
#ANCHOR:exported_properties
@export var max_speed := 600.0
#END:max_speed
#ANCHOR:new_props
## How much speed is added per second when the player presses a movement key.
@export var acceleration := 1200.0
## How much speed is lost per second when the player releases all movement keys.
@export var deceleration := 1080.0
#END:exported_properties
#END:new_props

#ANCHOR:skin
@onready var _skin: Sprite2D = %Skin
#END:skin

#ANCHOR:physics_process_top
#ANCHOR:physics_process_definition
func _physics_process(delta: float) -> void:
#END:physics_process_definition
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
#ANCHOR:has_input_direction
	var has_input_direction := direction.length() > 0.0
#END:has_input_direction
#ANCHOR:movement
	if has_input_direction:
		var desired_velocity := direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
#END:movement
#ANCHOR:move_and_slide
	move_and_slide()
#END:move_and_slide
#END:physics_process_top
	if not has_input_direction:
		return

#ANCHOR:match
	var direction_discrete := direction.sign()
	match direction_discrete:
		Vector2.RIGHT, Vector2.LEFT:
			_skin.texture = RUNNER_RIGHT
		Vector2.UP:
			_skin.texture = RUNNER_UP
		Vector2.DOWN:
			_skin.texture = RUNNER_DOWN
		UP_RIGHT, UP_LEFT:
			_skin.texture = RUNNER_UP_RIGHT
		DOWN_RIGHT, DOWN_LEFT:
			_skin.texture = RUNNER_DOWN_RIGHT
	if direction_discrete.length() > 0:
		_skin.flip_h = direction.x < 0.0
#END:match
