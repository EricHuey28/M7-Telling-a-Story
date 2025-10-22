#ANCHOR:l4_head
@icon("res://icons/icon_mob.svg")
class_name Mob extends Area2D
#END:l4_head

@export var speed := 100.0
@export var health := 100.0: set = set_health
@export var damage := 10.0

var _current_speed := speed

@onready var _bar_pivot: Node2D = %BarPivot
@onready var _health_bar: ProgressBar = %HealthBar


func _ready() -> void:
	#ANCHOR:setup_health
	_health_bar.max_value = health
	set_health(health)
	#END:setup_health

	area_entered.connect(func (_other_area: Area2D) -> void:
		_die()
	)



func _physics_process(_delta: float) -> void:
	_bar_pivot.global_rotation = 0.0


func set_health(new_health: float) -> void:
	health = maxf(0.0, new_health)

	if _health_bar != null:
		_health_bar.value = health

	if health <= 0.0:
		_die()


func take_damage(amount: float) -> void:
	#ANCHOR:subtract_health
	health -= amount
	#END:subtract_health

	#ANCHOR:display_damage
	var damage_indicator: Node2D = preload("damage_indicator.tscn").instantiate()
	get_tree().current_scene.add_child(damage_indicator)
	damage_indicator.global_position = global_position
	damage_indicator.display_amount(amount)
	#END:display_damage


func _die() -> void:
	queue_free()
