extends Area2D


#ANCHOR: _ready
func _ready() -> void:
	area_entered.connect(_on_area_entered)
#END:_ready

#ANCHOR:_on_area_entered_definition
func _on_area_entered(area_that_entered: Area2D) -> void:
#END:_on_area_entered_definition
#ANCHOR:_on_area_entered_body
	queue_free()
#END:_on_area_entered_body
