extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var wait_timer: Timer = $WaitTimer
@onready var shadow: Sprite2D = $Shadow


func _ready() -> void:
	# We alternate between waiting and hopping. For that, we make sure the timer node is set to one-shot mode.
	# This way it emits the timeout signal only once, and we can restart the timer manually after the hop animation is done.
	wait_timer.wait_time = randf_range(1.0, 3.0)
	wait_timer.one_shot = true
	wait_timer.timeout.connect(_animate_one_hop)
	wait_timer.start()


## Animates the bird hopping and moving to a random position.
func _animate_one_hop() -> void:
	# The duration of a single hop in seconds. We use it to calculate the duration of the entire hop animation.
	const HOP_DURATION := 0.25
	const HALF_HOP_DURATION := HOP_DURATION / 2.0

	var random_direction := Vector2(1.0, 0.0).rotated(randf() * 2.0 * PI)
	var land_position := random_direction * randf_range(0.0, 30.0)

	# The logic is similar to the items jumping from the chest. One difference is that we animate the shadow as well.
	var tween := create_tween().set_parallel()
	tween.tween_property(sprite_2d, "position:x", land_position.x, HOP_DURATION)
	tween.tween_property(shadow, "position", land_position, HOP_DURATION)

	# This animation makes the bird jump up and down.
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	const JUMP_HEIGHT := 16.0
	tween.tween_property(sprite_2d, "position:y", land_position.y - JUMP_HEIGHT, HALF_HOP_DURATION)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(sprite_2d, "position:y", land_position.y, HALF_HOP_DURATION)

	# For each hop, I randomize the timer's duration to make the bird's behavior more natural.
	wait_timer.wait_time = randf_range(1.0, 3.0)
	# I connect the tween's finished signal to the timer's start method. This way, the animation ends, there's a pause, and when the timer times out, the bird hops again.
	tween.finished.connect(wait_timer.start)
