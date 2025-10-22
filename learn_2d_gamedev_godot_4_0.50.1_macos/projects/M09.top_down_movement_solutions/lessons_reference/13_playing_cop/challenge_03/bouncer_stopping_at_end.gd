extends "../challenge_02/bouncer_slow_start.gd"

# This function allows us to change the bouncer animation and to stop it from moving.
# We call this from the main game script
func deactivate() -> void:
	set_physics_process(false)
	_runner_visual.animation_name = RunnerVisual.Animations.IDLE
	_dust.emitting = false
