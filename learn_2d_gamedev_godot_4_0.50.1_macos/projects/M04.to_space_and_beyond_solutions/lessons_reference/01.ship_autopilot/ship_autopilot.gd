extends Sprite2D

#ANCHOR:velocity_definition
var velocity := Vector2(480, -480)
#END:velocity_definition

func _process(delta: float) -> void:
	position += velocity * delta
#ANCHOR:rotation
	rotation = velocity.angle()
#END:rotation
