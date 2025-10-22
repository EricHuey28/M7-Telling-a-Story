class_name SettingsMenu
extends Control

var index_music_bus := AudioServer.get_bus_index("Music")
var index_sounds_bus := AudioServer.get_bus_index("Sounds")

@onready var go_back_button: Button = %GoBackButton

@onready var _music_slider: HSlider = %MusicHSlider
@onready var _sounds_slider: HSlider = %SoundHSlider


func _ready() -> void:
	_music_slider.value = AudioServer.get_bus_volume_linear(index_music_bus)
	print(_music_slider.value)
	_sounds_slider.value = AudioServer.get_bus_volume_linear(index_sounds_bus)

	_music_slider.value_changed.connect(
		func(value: float) -> void:
			AudioServer.set_bus_volume_db(index_music_bus, linear_to_db(value))
	)
	_sounds_slider.value_changed.connect(
		func(value: float) -> void:
			AudioServer.set_bus_volume_db(index_sounds_bus, linear_to_db(value))
	)
