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

#ANCHOR:max_speed
var max_speed := 600.0
#END:max_speed

#ANCHOR:node
@onready var _skin: Sprite2D = %Skin
#END:node

#ANCHOR:movement
#ANCHOR:physics_process_definition
func _physics_process(_delta: float) -> void:
#END:physics_process_definition
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * max_speed
	move_and_slide()
#END:movement
#ANCHOR:directions_first_two
	if direction.x > 0.0 and direction.y > 0.0:
		_skin.texture = RUNNER_DOWN_RIGHT
	elif direction.x < 0.0 and direction.y > 0.0:
		_skin.texture = RUNNER_DOWN_LEFT
#END:directions_first_two
#ANCHOR:directions_last
	elif direction.x > 0.0 and direction.y < 0.0:
		_skin.texture = RUNNER_UP_RIGHT
	elif direction.x < 0.0 and direction.y < 0.0:
		_skin.texture = RUNNER_UP_LEFT
	elif direction.x > 0.0:
		_skin.texture = RUNNER_RIGHT
	elif direction.x < 0.0:
		_skin.texture = RUNNER_LEFT
	elif direction.y > 0.0:
		_skin.texture = RUNNER_DOWN
	elif direction.y < 0.0:
		_skin.texture = RUNNER_UP
#END:directions_last
