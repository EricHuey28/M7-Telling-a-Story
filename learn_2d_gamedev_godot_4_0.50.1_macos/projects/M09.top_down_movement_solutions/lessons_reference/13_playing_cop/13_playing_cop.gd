extends "res://lessons_reference/09_countdown/09_count_down.gd"

#ANCHOR:bouncer_ref
@onready var _bouncer: CharacterBody2D = %Bouncer
#END:bouncer_ref

func _ready() -> void:
	#ANCHOR:_ready_body
	_bouncer.set_physics_process(false)

	_count_down.counting_finished.connect(
		func() -> void:
	#ANCHOR:connect_countdown_tail
			_bouncer.set_physics_process(true)
	)
	#END:connect_countdown_tail
	#END:_ready_body
	super()
