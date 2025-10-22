@tool
extends "res://addons/gdpractice/metadata.gd"

func _init() -> void:
	list += [
		PracticeMetadata.new(
			"07_telling_a_story_010_pick_correct_response",
			"Pick the Correct Response",
			preload ("L5.P1.pick_correct_response/pick_correct_response.tscn")
		),
		PracticeMetadata.new(
			"07_telling_a_story_020_text_slideshow",
			"Text Slideshow",
			preload ("L5.P2.text_slideshow/text_slideshow.tscn")
		),
		PracticeMetadata.new(
			"07_telling_a_story_030_poetry",
			"A Poem About Becoming a Gamedev",
			preload ("L6.P1.poetry/poetry.tscn")
		),
		PracticeMetadata.new(
			"07_telling_a_story_040_typewriter",
			"A Typewritten Poem About Becoming a Gamedev",
			preload ("L6.P2.typewriter/typewriter.tscn")
		),
		PracticeMetadata.new(
			"07_telling_a_story_050_pick_your_character",
			"Picking Your Character",
			preload ("L8.P1.pick_your_character/pick_your_character.tscn")
		),
		PracticeMetadata.new(
			"07_telling_a_story_060_image_slideshow",
			"Images Slideshow",
			preload ("L10.P1.image_slideshow/image_slideshow.tscn")
		),
		PracticeMetadata.new(
			"07_telling_a_story_070_party_members_menu",
			"Party Members Menu",
			preload ("L10.P2.party_members/party_members.tscn")
		),
	]
