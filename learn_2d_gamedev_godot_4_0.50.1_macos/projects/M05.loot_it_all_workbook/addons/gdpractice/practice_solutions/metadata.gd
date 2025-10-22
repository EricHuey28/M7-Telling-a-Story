@tool
extends "res://addons/gdpractice/metadata.gd"


func _init() -> void:
	list += [
		PracticeMetadata.new(
			"05_loot_it_all_010_pop_the_ball",
			"Pop the ball",
			preload("res://addons/gdpractice/practice_solutions/L2.P1.pop_the_ball/pop_the_ball.tscn")
		),
		PracticeMetadata.new(
			"05_loot_it_all_020_code_an_energy_pack",
			"Code an energy pack",
			preload("res://addons/gdpractice/practice_solutions/L5.P1.code_an_energy_pack/code_an_energy_pack.tscn")
		),
		PracticeMetadata.new(
			"05_loot_it_all_030_create_coins",
			"Create coins",
			preload("res://addons/gdpractice/practice_solutions/L6.P1.create_coins/create_coins.tscn")
		),
		PracticeMetadata.new(
			"05_loot_it_all_040_coins_and_energy_packs",
			"Collect coins and energy packs",
			preload(
				"res://addons/gdpractice/practice_solutions/L6.P2.coins_and_energy_packs/coins_and_energy_packs.tscn"
			)
		),
		PracticeMetadata.new(
			"05_loot_it_all_050_spawn_random_items",
			"Spawn random items",
			preload("res://addons/gdpractice/practice_solutions/L7.P1.spawn_random_items/spawn_random_items.tscn")
		),
	]
