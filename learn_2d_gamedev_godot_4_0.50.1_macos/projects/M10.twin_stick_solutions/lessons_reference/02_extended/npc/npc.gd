extends Area2D

@export var dialogue: Dialogue = null

var player: Player = null

@onready var _dialogue_box: DialogueBox = %DialogueBox


func _ready() -> void:
	_dialogue_box.hide()

	body_entered.connect(func (body: Node) -> void:
		if body is Player:
			player = body
	)
	body_exited.connect(func (body: Node) -> void:
		if body is Player:
			player = null
	)


#ANCHOR:_unhandled_input
func _unhandled_input(event: InputEvent) -> void:
	if player != null and event.is_action_pressed("interact"):
		play_dialogue(dialogue)
		#END:_unhandled_input

	if event.is_action_pressed("move_up"):
		play_dialogue(dialogue)

func play_dialogue(dialogue: Dialogue) -> void:
	if player == null:
		return

	player.set_physics_process(false)
	_dialogue_box.show()
	_dialogue_box.dialogue = dialogue
	_dialogue_box.play_dialogue()
	if not _dialogue_box.dialogue_finished.is_connected(
		player.set_physics_process
	):
		_dialogue_box.dialogue_finished.connect(
			player.set_physics_process.bind(true)
		)
