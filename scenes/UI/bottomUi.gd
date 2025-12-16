class_name BottomUi
extends Control


func _on_main_menu_button_button_down():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_single_match_button_down():
	var test = Game.matches[0]
	print(test.awayTeam.name)
	var testScene: SingleMatch = preload("res://match/single_match.tscn").instantiate()
	testScene.setMatch(test)
	print(testScene.singleMatch)
	get_tree().root.add_child(testScene)


func _on_matchday_button_button_down():
	get_tree().change_scene_to_file("res://match/matchday.tscn")


func _on_table_button_button_down():
	get_tree().change_scene_to_file("res://scenes/table/table_scene.tscn")


func _on_next_matchday_button_button_down():
	print_debug("On NExt Matchday button down")
	EventBus.emit_next_matchday()


func _on_simulate_season_button_button_down():
	Game.current_season.simulate_season()


func _on_line_up_button_down():
	get_tree().change_scene_to_file("res://scenes/lineup/lineUp.tscn")


func _on_club_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/club/club.tscn")


func _on_next_button_button_up() -> void:
	EventBus.emit_next()
