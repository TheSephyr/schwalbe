extends Window

@onready var scene_name: Label = $VBoxContainer/HBoxContainer/SceneName


func _ready() -> void:
	scene_name.text = get_tree().current_scene.name


func _on_simulate_season_pressed() -> void:
	Game.player_season().simulate_season()
	Game.player_season().finished = true
	Game.current_date = Game.player_season().matchdays[-1].date
	get_tree().change_scene_to_file("res://scenes/season_end/season_end.tscn")


func _on_skip_half_pressed() -> void:
	var season := Game.player_season()
	var mid: int = GameConfig.WINTER_BREAK_AFTER_MD
	if season.current_matchday <= mid:
		season.simulate_up_to(mid)
		Game.current_date = season.matchdays[mid - 1].date
		GameState.last_matchday = season.matchdays[mid - 1]
		get_tree().change_scene_to_file("res://scenes/matchday_view.tscn")
	else:
		season.simulate_up_to(season.matchdays.size())
		Game.current_date = season.matchdays[-1].date
		get_tree().change_scene_to_file("res://scenes/season_end/season_end.tscn")


func _on_close_requested() -> void:
	queue_free()
