class_name Rocket_2 extends Area2D

@export var speed := 350.0
@export var damage := 10.0
@export var max_distance := 1000.0

var _traveled_distance := 0.0


func _ready() -> void:
	collision_layer = 0
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

	_traveled_distance += speed * delta
	if _traveled_distance > max_distance:
		_explode()


func _explode() -> void:
	queue_free()


# Keeping this as a separate function allows changing the damage behavior on different rockets.
func _on_area_entered(other_area: Area2D) -> void:
	var mob := other_area as Mob_2
	if mob != null:
		mob.take_damage(damage)
		_explode()
