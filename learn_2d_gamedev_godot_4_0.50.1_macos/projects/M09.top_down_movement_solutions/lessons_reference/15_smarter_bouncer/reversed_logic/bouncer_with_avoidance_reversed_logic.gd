extends "../bouncer_with_avoidance.gd"

func _physics_process(delta: float) -> void:
	# Get base direction to player
	var base_direction := global_position.direction_to(get_global_player_position())
	# Keep the final direction in a different variable, because we will need 
	# the `base_direction` variable to remain untouched
	var final_direction := base_direction
	
	# Add influences from each Raycast, weighted by dot product
	# "dot product" calculates the difference between two angles. We want to 
	# weight more strongly raycasts that are close to the desired direction.
	for ray: RayCast2D in _raycasts.get_children():
		# if a ray is colliding, we consider its influence none. We only want to keep vectors
		# that are not colliding.
		# A more complicated version might weight vectors depending on their collision point.
		if not ray.is_colliding():
			# we get the target position of the uncolliding ray
			var ray_direction := ray.target_position.normalized()
			# Dot product will be 1 when aligned, 0 when perpendicular, -1 when opposite
			var alignment := base_direction.dot(ray_direction)
			# Only consider directions that are somewhat aligned with our goal
			if alignment > 0:
				final_direction += ray_direction * alignment
	
	# We now have a vector made of our main desired direction, and every other vector added to it.
	# We can normalize it.
	final_direction = final_direction.normalized()
	velocity = final_direction * max_speed

	if velocity.length() > 10.0:
		_runner_visual.angle = rotate_toward(_runner_visual.angle, final_direction.orthogonal().angle(), 8.0 * delta)
		_raycasts.rotation = _runner_visual.angle
		
	move_and_slide()
