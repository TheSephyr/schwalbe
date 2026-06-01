extends Control

var _selected_index: int = -1

@onready var team_list: ItemList = $MarginContainer/VBoxContainer/TeamList
@onready var select_button: Button = $MarginContainer/VBoxContainer/SelectButton


func _ready() -> void:
	for club: Club in Game.player_league.clubs:
		team_list.add_item(club.name)


func _on_team_list_item_selected(index: int) -> void:
	_selected_index = index
	select_button.disabled = false


func _on_select_button_pressed() -> void:
	Game.player_club = Game.player_league.clubs[_selected_index]
	Game.player_club.trainer = Trainer.new(
		Game.trainer_lastname, Game.trainer_firstname, Game.trainer_birthdate
	)
	get_tree().change_scene_to_file("res://scenes/preseason/preseason_scene.tscn")
