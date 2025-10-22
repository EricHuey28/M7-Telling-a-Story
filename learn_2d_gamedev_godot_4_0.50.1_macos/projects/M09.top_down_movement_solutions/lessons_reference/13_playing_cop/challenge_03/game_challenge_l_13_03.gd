extends  "../13_playing_cop.gd"


func _ready() -> void:
	super()
	
	_finish_line.body_entered.connect(func (body: Node) -> void:
		_bouncer.deactivate()
	)
