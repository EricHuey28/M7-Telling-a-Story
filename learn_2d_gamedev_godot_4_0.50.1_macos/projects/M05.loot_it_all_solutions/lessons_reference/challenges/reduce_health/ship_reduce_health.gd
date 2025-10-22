# This extends the ship script so I don't have to duplicate all the code.
# I can just extend it and add new features to it.
extends "res://lessons_reference/05.completed/ship_final.gd"


func _ready() -> void:
	# This means "extend the ready function of the ship_final.gd script
	# instead of replacing it.
	# You'll learn how this works later in the course.
	super()
	set_health(100)
	get_node("Timer").timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	set_health(health - 5)
	if health <= 0:
		get_tree().reload_current_scene()
