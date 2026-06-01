extends Control

var _selected_index: int = -1

@onready var league_list: VBoxContainer = $CenterContainer/ContentVBox/SelectionPanel/Margin/VBox/LeagueListVBox
@onready var weiter_button: Button = $CenterContainer/ContentVBox/SelectionPanel/Margin/VBox/WeiterButton


func _ready() -> void:
	weiter_button.disabled = true
	var button_group := ButtonGroup.new()
	for i: int in Game.leagues.size():
		var league: League = Game.leagues[i]
		var btn := Button.new()
		btn.text = league.name
		btn.toggle_mode = true
		btn.button_group = button_group
		btn.pressed.connect(_on_league_selected.bind(i))
		league_list.add_child(btn)


func _on_league_selected(index: int) -> void:
	_selected_index = index
	weiter_button.disabled = false


func _on_weiter_pressed() -> void:
	Game.player_league = Game.leagues[_selected_index]
	Game.player_club = Game.player_league.clubs[0]
	get_tree().change_scene_to_file("res://scenes/manager_setup/manager_setup_scene.tscn")
