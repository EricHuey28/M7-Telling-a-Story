extends Area2D

@export var possible_candies: Array[PackedScene] = [
	# Calling preload() like this is equivalent to adding the candies in the Inspector.
	preload("./candy/candy_blue.tscn"),
	preload("./candy/candy_green.tscn"),
	preload("./candy/candy_red.tscn")
]


func _ready() -> void:
	randomize()


func _input_event(viewport: Viewport, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	)

	if event_is_mouse_click:
		input_pickable = false
		# Create three candies! Hint: change the for loop range to spawn multiple candies.
		for current_index in range(3):  # for current_index in range(0):
			spawn_candy()


func spawn_candy() -> void:
	# Instantiate and add a random candy as a child of the piñata.
	# Use the possible_candies.pick_random() function to pick a random candy.
	var candy: Node2D = possible_candies.pick_random().instantiate() # var candy: Node2D = null
	add_child(candy)

	# Complete the variables to calculate a random position in a circle using polar coordinates.
	var random_angle := randf_range(0.0, 2.0 * PI)  # var random_angle := 0.0
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)  # var random_direction := Vector2()
	# The random distance should be a random value between 0 and 100.
	var random_distance := randf_range(0.0, 100.0) # var random_distance := 0.0

	# Finally, position the candy at the calculated random position.
	candy.position = random_direction * random_distance #
