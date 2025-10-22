## This version of the bird uses math to animate the bird hopping.
## We have a function, _update_hop_height, that calculates the height of the bird sprite based on the progress of a hop.
## It makes it easy to chain multiple hops together and randomize the number of hops between each wait period.
# This version was beyond the scope of the module. We often write a lot more code than
# you can find in the lessons, searching for a good learning flow and difficulty
# curve. Tweens are very general, reusable knowledge while learning math tricks
# for animation is more specialized. Still, I left some comments if you'd like
# to read and learn from this version.
extends Node2D

## Radius within which the bird moves to a random position.
@export var random_move_radius := 100.0
## Number of times the bird hops per second when hopping.
@export var hop_frequency := 4.0


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var wait_timer: Timer = $WaitTimer


func _ready() -> void:
	# We alternate between waiting and hopping. When the wait_timer times out, we start hopping.
	wait_timer.wait_time = randf_range(2.0, 5.0)
	wait_timer.timeout.connect(_animate_hops)
	wait_timer.start()


## Animates the bird hopping and moving to a random position.
func _animate_hops() -> void:
	# In this version, we randomize the number of hops the bird makes.
	# This works without loops thanks to the tween_method function and the use of
	# periodic functions to calculate the vertical offset of the bird sprite.
	var hop_count := randi_range(1, 5)
	var tween := create_tween().set_parallel()
	# The duration of a single hop in seconds. We use it to calculate the duration of the entire hop animation.
	var hop_duration := 1.0 / hop_frequency
	var duration := hop_duration * hop_count

	tween.tween_method(_update_hop_height, 0.0, float(hop_count), duration)

	var random_direction := Vector2(1.0, 0.0).rotated(randf() * 2.0 * PI)
	var random_target_position := random_direction * random_move_radius * randf()
	tween.tween_property(sprite_2d, "position", random_target_position, duration)

	wait_timer.wait_time = randf_range(2.0, 5.0)
	tween.finished.connect(wait_timer.start)


## Offsets the bird sprite vertically to simulate hopping.
## The value of hop_progress can go beyond 1.0.
## A value animating from 0.0 to 1.0 will make the bird hop once.
## From 1.0 to 2.0 will make it hop a second time, and so on.
func _update_hop_height(hop_progress: float) -> void:
	const HOP_HEIGHT := 8.0
	var sine_wave := sin(hop_progress * PI)
	var hop_current_height: float = -1.0 * abs(sine_wave) * HOP_HEIGHT
	# We use the Sprite2D node's offset property to move the sprite up and down.
	# The offset property offsets the sprite relative to its position.
	# It makes it easy to layer multiple animations on top of each other.
	sprite_2d.offset.y = hop_current_height
