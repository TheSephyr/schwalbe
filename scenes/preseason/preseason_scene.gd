extends Control


func _ready() -> void:
	Game.ai_assign_sponsors()


func _on_kalkulation_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/calculation_scene.tscn")


func _on_start_season_pressed() -> void:
	if Game.player_club.sponsor_income > 0:
		Game.player_club.money += Game.player_club.sponsor_income
	get_tree().change_scene_to_file("res://scenes/club_overview.tscn")
