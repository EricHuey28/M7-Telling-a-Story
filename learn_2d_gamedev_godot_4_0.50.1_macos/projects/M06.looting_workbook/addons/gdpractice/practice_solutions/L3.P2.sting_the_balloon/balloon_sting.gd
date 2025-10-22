extends Area2D


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)  # pass


func _on_mouse_entered() -> void:
	queue_free()  # pass
