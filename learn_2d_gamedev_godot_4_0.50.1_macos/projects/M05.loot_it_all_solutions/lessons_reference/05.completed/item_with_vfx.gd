# Script for pickable items. Godot offers great options for composing scenes,
# and this is a good example of that.
#
# It's a plain script we can attach to any Area2D node with a child Sprite2D
# node, and the script will make the item float and disappear when the player
# touches it.
extends Area2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)
#ANCHOR:call_play_floating_animation
	play_floating_animation()
#END:call_play_floating_animation


#ANCHOR: play_floating_animation_definition
func play_floating_animation() -> void:
#END: play_floating_animation_definition
#ANCHOR: create_tween
	var tween := create_tween()
#END: create_tween
#ANCHOR: change_tween_transition
	tween.set_trans(Tween.TRANS_SINE)
#END: change_tween_transition

#ANCHOR: get_sprite_node
	var sprite_2d := get_node("Sprite2D")
#END: get_sprite_node
#ANCHOR: position_offset
	var position_offset := Vector2(0.0, 4.0)
#END: position_offset
#ANCHOR: duration
	var duration = randf_range(0.8, 1.2)
#END: duration
#ANCHOR: tween_position
	tween.tween_property(sprite_2d, "position", position_offset, duration)
	tween.tween_property(sprite_2d, "position",  -1.0 * position_offset, duration)
#END: tween_position
#ANCHOR: make_tween_loop
	tween.set_loops()
#END: make_tween_loop


func _on_area_entered(area_that_entered: Area2D) -> void:
	queue_free()
