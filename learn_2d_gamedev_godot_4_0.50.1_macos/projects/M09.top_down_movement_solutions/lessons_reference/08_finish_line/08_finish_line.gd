#ANCHOR:header
extends Node2D
#END:header

#ANCHOR:finish_line_ref
@onready var _finish_line: FinishLine = %FinishLine
#END:finish_line_ref

#ANCHOR:ready
func _ready() -> void:
	#ANCHOR:body_entered_connection
	_finish_line.body_entered.connect(func (body: Node) -> void:
	#END:body_entered_connection
		#ANCHOR:is_discriminant
		if body is not Runner:
			return
		#END:is_discriminant
		#ANCHOR:casting
		var runner := body as Runner
		#END:casting

		#ANCHOR:disable
		runner.set_physics_process(false)
		#END:disable
		#ANCHOR:target_position
		var destination_position := (
			_finish_line.global_position
			+ Vector2(0, 64)
		)
		#END:target_position

		#ANCHOR:walk_to
		runner.walk_to(destination_position)
		#END:walk_to
		#ANCHOR:signal_walked_to
		runner.walked_to.connect(
			_finish_line.pop_confettis
		)
		#END:signal_walked_to
	)

	#ANCHOR:signal_confetti_finished
	_finish_line.confettis_finished.connect(
		get_tree().reload_current_scene.call_deferred
	)
	#END:signal_confetti_finished
	#END:ready
