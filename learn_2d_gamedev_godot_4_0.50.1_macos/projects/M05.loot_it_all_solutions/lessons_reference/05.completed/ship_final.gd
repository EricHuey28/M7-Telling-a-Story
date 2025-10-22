extends Area2D


var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0

var health := 10
var gem_count := 0


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	set_health(health)


#ANCHOR: _process_definition
func _process(delta: float) -> void:
#END: _process_definition
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	var desired_velocity := max_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * steering_factor * delta
	position += velocity * delta
	
#ANCHOR: viewport_size
	var viewport_size := get_viewport_rect().size
#END: viewport_size
#ANCHOR: wrapf
	position.x = wrapf(position.x, 0, viewport_size.x)
	position.y = wrapf(position.y, 0, viewport_size.y)
#END: wrapf

	if velocity.length() > 0.0:
		get_node("Sprite2D").rotation = velocity.angle()


func set_gem_count(new_gem_count: int) -> void:
	gem_count = new_gem_count
	get_node("UI/GemCount").text = "x" + str(gem_count)


func set_health(new_health: int) -> void:
	health = new_health
	get_node("UI/HealthBar").value = health


func _on_area_entered(area_that_entered: Area2D) -> void:
	if area_that_entered.is_in_group("gem"):
		set_gem_count(gem_count + 1)
	elif area_that_entered.is_in_group("healing_item"):
		set_health(health + 10)
