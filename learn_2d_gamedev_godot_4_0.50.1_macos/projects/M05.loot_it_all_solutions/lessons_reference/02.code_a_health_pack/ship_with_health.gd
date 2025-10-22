extends Area2D

var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0

#ANCHOR: health
var health := 10
#END: health


#ANCHOR: _ready
#ANCHOR: _ready_connect
func _ready() -> void:
	area_entered.connect(_on_area_entered)
#END: _ready_connect
	# This call updates the health bar to match the health variable when the
	# game starts.
	set_health(health)
#END: _ready


func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	var desired_velocity := max_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * steering_factor * delta
	position += velocity * delta

#ANCHOR: rotation_condition
	if velocity.length() > 0.0:
#END: rotation_condition
#ANCHOR: rotation
		get_node("Sprite2D").rotation = velocity.angle()
#END: rotation


#ANCHOR: set_health_definition
func set_health(new_health: int) -> void:
#END: set_health_definition
#ANCHOR: update_health_variable
	health = new_health
#END: update_health_variable
#ANCHOR: update_health_bar
	get_node("UI/HealthBar").value = health
#END: update_health_bar


#ANCHOR: _on_area_entered
func _on_area_entered(area_that_entered: Area2D) -> void:
#ANCHOR: health_increase
	set_health(health + 10)
#END: health_increase
#END: _on_area_entered
