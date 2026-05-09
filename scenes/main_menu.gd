extends Control

@onready var continue_button: Button = $ContinueButton


func _ready() -> void:
	continue_button.visible = Game.has_save()


func _on_quit_game_button_button_down() -> void:
	get_tree().quit()


func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/team_selection.tscn")


func _on_continue_button_pressed() -> void:
	Game.load_game()
	get_tree().change_scene_to_file("res://scenes/club_overview.tscn")
