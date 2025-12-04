extends Control

signal nextMatchday

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_button_button_down():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	  
	pass # Replace with function body.


func _on_single_match_button_down():
	var test = Game.matches[0]
	print(test.awayTeam.name)
	var testScene: SingleMatch = preload("res://match/single_match.tscn").instantiate()
	testScene.setMatch(test)
	print(testScene.singleMatch)
	#get_node("/root/Game").free()
	get_tree().root.add_child(testScene)
	#get_tree().change_scene_to_packed(test)
	#get_tree().change_scene_to_file("res://single_match.tscn")
	pass # Replace with function body.


func _on_matchday_button_button_down():
	get_tree().change_scene_to_file("res://match/matchday.tscn")
	pass # Replace with function body.


func _on_table_button_button_down():
	get_tree().change_scene_to_file("res://scenes/table/table_scene.tscn")
	pass # Replace with function body.


func _on_next_matchday_button_button_down():
	print_debug("On NExt Matchday button down")
	Game.nextMatchday()
	nextMatchday.emit()
	pass # Replace with function body.


func _on_simulate_season_button_button_down():
	Game.currentSeason.simulateSeason()
	pass # Replace with function body.


func _on_line_up_button_down():
	get_tree().change_scene_to_file("res://scenes/lineup/lineUp.tscn")
	pass # Replace with function body.


func _on_club_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/club/club.tscn")
	pass # Replace with function body.
