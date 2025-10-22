#ANCHOR:class_name
@icon("res://icons/icon_rocket.svg")
class_name Rocket extends Area2D
#END:class_name

@export var speed := 350.0
@export var max_distance := 1000.0
@export var damage := 20

var _traveled_distance := 0.0


func _init() -> void:
	monitorable = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

	_traveled_distance += speed * delta
	if _traveled_distance > max_distance:
		_explode()


func _explode() -> void:
	queue_free()


func _on_area_entered(other_area: Area2D) -> void:
	if other_area is Mob:
		other_area.take_damage(damage)
		_explode()
