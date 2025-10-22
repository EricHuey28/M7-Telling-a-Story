class_name Runner
extends "../07_im_on_fire/07_runner.gd"

#ANCHOR:walked_to_signal
## Emitted when the character has walked to the specified destination.
signal walked_to
#END:walked_to_signal


#ANCHOR:walk_to_function
## Forces the character to walk to a position ignoring collisions[br]
## [param destination_global_position]: The desired destination, given in global coordinates.
#ANCHOR:walk_to_signature
func walk_to(destination_global_position: Vector2) -> void:
#END:walk_to_signature
	# obtain the direction and angle
#ANCHOR:direction
	var direction := global_position.direction_to(destination_global_position)
	_runner_visual.angle = direction.orthogonal().angle()
#END:direction

	# Set the proper animation name
#ANCHOR:animation
	_runner_visual.animation_name = RunnerVisual.Animations.WALK
	_dust.emitting = true
#END:animation

	# obtain distance, and calculate direction from that
#ANCHOR:duration
	var distance := global_position.distance_to(destination_global_position)
	var duration :=  distance / (max_speed * 0.2)
#END:duration

	# tween the runner to destination, then emit `walked_to`
#ANCHOR:walk_to_tween
	var tween := create_tween()
	tween.tween_property(self, "global_position", destination_global_position, duration)
	tween.finished.connect(func():
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false
		walked_to.emit()
	)
#END:walk_to_tween
#END:walk_to_function
