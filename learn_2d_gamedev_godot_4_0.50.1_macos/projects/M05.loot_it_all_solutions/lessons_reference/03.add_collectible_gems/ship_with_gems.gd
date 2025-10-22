extends Area2D

var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0

var health := 10
#ANCHOR: gem_count
var gem_count := 0
#END: gem_count


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	set_health(health)


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

	if velocity.length() > 0.0:
		get_node("Sprite2D").rotation = velocity.angle()


#ANCHOR: set_gem_count_definition
func set_gem_count(new_gem_count: int) -> void:
#END: set_gem_count_definition
#ANCHOR: set_gem_count_value
	gem_count = new_gem_count
#END: set_gem_count_value
#ANCHOR: set_gem_count_text
	get_node("UI/GemCount").text = "x" + str(gem_count)
#END: set_gem_count_text


func set_health(new_health: int) -> void:
	health = new_health
	get_node("UI/HealthBar").value = health


#ANCHOR: _on_area_entered_definition
func _on_area_entered(area_that_entered: Area2D) -> void:
#END: _on_area_entered_definition
#ANCHOR: _on_area_entered_body
	#ANCHOR: if_in_group_gem
	if area_that_entered.is_in_group("gem"):
		set_gem_count(gem_count + 1)
	#END: if_in_group_gem
	#ANCHOR: if_in_group_healing_item
	elif area_that_entered.is_in_group("healing_item"):
		set_health(health + 10)
	#END: if_in_group_healing_item
#END: _on_area_entered_body

