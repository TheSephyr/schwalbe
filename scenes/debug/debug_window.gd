extends Window

@onready var scene_name: Label = $VBoxContainer/HBoxContainer/SceneName


func _ready() -> void:
	scene_name.text = get_tree().current_scene.name


func _on_simulate_season_pressed() -> void:
	Game.current_season.simulate_season()
	Game.current_season.finished = true
	Game.current_date = Game.current_season.matchdays[-1].date
	get_tree().change_scene_to_file("res://scenes/season_end/season_end.tscn")


func _on_close_requested() -> void:
	queue_free()
