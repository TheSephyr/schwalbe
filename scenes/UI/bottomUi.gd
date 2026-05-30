class_name BottomUi
extends Control


func _on_clubs_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/clubs/clubs_scene.tscn")


func _on_matchday_button_button_down():
	get_tree().change_scene_to_file("res://match/matchday.tscn")


func _on_table_button_button_down():
	get_tree().change_scene_to_file("res://scenes/table/table_scene.tscn")


func _on_line_up_button_down():
	get_tree().change_scene_to_file("res://scenes/lineup/lineUp.tscn")


func _on_taktik_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/tactics/tactics_scene.tscn")


func _on_club_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/club/club.tscn")


func _on_balance_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/balance/balance_scene.tscn")


func _on_kalender_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/calendar/calendar_scene.tscn")


func _on_training_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/training/training_scene.tscn")


func _on_einzeltraining_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/individual_training/individual_training_scene.tscn")


func _on_suche_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/player_search/player_search_scene.tscn")


func _on_transfers_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/transfer_market/transfer_market_scene.tscn")


func _on_stadion_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/stadium/stadium_scene.tscn")


func _on_ausgaben_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/expenditure/expenditure_scene.tscn")


func _on_personal_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/personal/personal_scene.tscn")


func _on_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/settings/settings_scene.tscn")


func _on_next_button_button_up() -> void:
	EventBus.emit_next()
