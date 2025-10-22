extends ColorRect

@onready var texture_rect: TextureRect = %TextureRect
@onready var button_dani: Button = %ButtonDani
@onready var button_gobot: Button = %ButtonGobot
@onready var button_nova: Button = %ButtonNova

var character_choices := {
	"dani": preload("./assets/character_dani.png"),
	"gobot": preload("./assets/character_gdbot.png"),
	"nova": preload("./assets/character_nova.png")
}

func _ready() -> void:
	texture_rect.texture = character_choices["dani"]
	button_dani.pressed.connect(
		func() -> void:
			texture_rect.texture = character_choices["dani"]
	)
	# Make the Gobot and Nova buttons work by adding code below.
	button_gobot.pressed.connect( #
		func() -> void: #
			texture_rect.texture = character_choices["gobot"] #
	) #
	button_nova.pressed.connect( #
		func() -> void: #
			texture_rect.texture = character_choices["nova"] #
	) #
