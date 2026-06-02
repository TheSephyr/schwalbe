extends Control

var _selected_league_index: int = -1
var _league_button_group: ButtonGroup

@onready var nation_list: VBoxContainer = $CenterContainer/ContentVBox/SelectionPanel/Margin/VBox/ColumnsHBox/NationColumn/NationListVBox
@onready var league_column: VBoxContainer = $CenterContainer/ContentVBox/SelectionPanel/Margin/VBox/ColumnsHBox/LeagueColumn
@onready var league_list: VBoxContainer = $CenterContainer/ContentVBox/SelectionPanel/Margin/VBox/ColumnsHBox/LeagueColumn/LeagueListVBox
@onready var weiter_button: Button = $CenterContainer/ContentVBox/SelectionPanel/Margin/VBox/WeiterButton


func _ready() -> void:
	weiter_button.disabled = true
	league_column.visible = false
	var nation_button_group := ButtonGroup.new()
	var seen_nations: Array[String] = []
	for league: League in Game.leagues:
		if league.nation not in seen_nations:
			seen_nations.append(league.nation)
	for nation: String in seen_nations:
		var btn := Button.new()
		btn.text = nation
		btn.toggle_mode = true
		btn.button_group = nation_button_group
		btn.pressed.connect(_on_nation_selected.bind(nation))
		nation_list.add_child(btn)


func _on_nation_selected(nation: String) -> void:
	for child in league_list.get_children():
		child.queue_free()
	_selected_league_index = -1
	weiter_button.disabled = true
	_league_button_group = ButtonGroup.new()
	for i: int in Game.leagues.size():
		var league: League = Game.leagues[i]
		if league.nation != nation:
			continue
		var btn := Button.new()
		btn.text = league.name
		btn.toggle_mode = true
		btn.button_group = _league_button_group
		btn.pressed.connect(_on_league_selected.bind(i))
		league_list.add_child(btn)
	league_column.visible = true


func _on_league_selected(index: int) -> void:
	_selected_league_index = index
	weiter_button.disabled = false


func _on_weiter_pressed() -> void:
	Game.player_league = Game.leagues[_selected_league_index]
	Game.player_club = Game.player_league.clubs[0]
	get_tree().change_scene_to_file("res://scenes/manager_setup/manager_setup_scene.tscn")
