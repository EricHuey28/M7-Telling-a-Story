extends Area2D

#ANCHOR:canvas_group
@onready var canvas_group: CanvasGroup = $CanvasGroup
#END:canvas_group

func _ready() -> void:
#ANCHOR:connect_mouse_signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
#END:connect_mouse_signals
#ANCHOR:_ready_line_thickness
	canvas_group.material.set_shader_parameter("line_thickness", 3.0)
#END:_ready_line_thickness

#ANCHOR:set_outline_thickness
func set_outline_thickness(new_thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", new_thickness)
#END:set_outline_thickness

#ANCHOR:_on_mouse_entered_definition
func _on_mouse_entered() -> void:
#END:_on_mouse_entered_definition
#ANCHOR:_on_mouse_entered_tween
	var tween := create_tween()
#ANCHOR:tween_grow_outline
	tween.tween_method(set_outline_thickness, 3.0, 6.0, 0.08)
#END:tween_grow_outline
#END:_on_mouse_entered_tween

#ANCHOR:_on_mouse_exited_definition
func _on_mouse_exited() -> void:
#END:_on_mouse_exited_definition
#ANCHOR:_on_mouse_exited_tween
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 6.0, 3.0, 0.08)
#END:_on_mouse_exited_tween
