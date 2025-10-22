extends "res://lessons_reference/08_finish_line/08_finish_line.gd"

#ANCHOR:node_refs
@onready var _count_down: CountDown = %CountDown
@onready var _runner: Runner = %Runner
#END:node_refs


#ANCHOR:_ready
func _ready() -> void:
#ANCHOR:start_countdown
	_count_down.start_counting()
#END:start_countdown
#ANCHOR:stop_runner
	_runner.set_physics_process(false)
#END:stop_runner

#ANCHOR:connect_countdown_finished
	#ANCHOR:connect_countdown_head
	_count_down.counting_finished.connect(
		func() -> void:
			_runner.set_physics_process(true)
			#END:connect_countdown_head
	)
#END:connect_countdown_finished
#END:_ready
	super()
