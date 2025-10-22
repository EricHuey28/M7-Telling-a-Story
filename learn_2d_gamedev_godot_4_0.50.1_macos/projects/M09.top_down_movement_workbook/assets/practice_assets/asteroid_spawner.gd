extends Node2D

const AsteroidScene := preload("asteroid_for_practice.tscn")

# Total extents of the asteroid field
@export var field_size := Vector2(4000.0, 2800.0)
# Area centered on the player where asteroids will not spawn
@export var safe_zone := Vector2(1920.0, 1080.0)
@export var total_asteroids := 100


func _ready() -> void:
	for i in total_asteroids:
		var asteroid := AsteroidScene.instantiate()
		asteroid.global_position = _get_random_location()
		add_child(asteroid)


# Generates a random location within the asteroid field, ensuring it is outside the safe zone.
func _get_random_location() -> Vector2:
	var x := randf_range(-field_size.x / 2.0, field_size.x / 2.0)
	var y := randf_range(-field_size.y / 2.0, field_size.y / 2.0)

	# If the position falls within the safe zone, push away from the center to the edges of the safe zone
	if absf(x) < safe_zone.x / 2.0 and absf(y) < safe_zone.y / 2.0:
		var direction := Vector2(x, y).normalized()
		return Vector2(x, y) + Vector2(safe_zone.x / 2.0 - absf(x), safe_zone.y / 2.0 - absf(y)) * direction

	return Vector2(x, y)
