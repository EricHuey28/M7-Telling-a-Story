# Script for pickable items. Godot offers great options for composing scenes, and this is a good example of that.
# It's a plain script we can attach to any Area2D node with a child Sprite2D node, and the script will make the item float and disappear when the player touches it.
extends Area2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area_that_entered: Area2D) -> void:
	queue_free()
