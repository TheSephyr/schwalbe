extends Control

@onready var continue_button: Button = $CenterContainer/ContentVBox/ButtonPanel/ButtonMargin/ButtonVBox/ContinueButton


func _ready() -> void:
	continue_button.visible = Game.has_any_save()


func _on_quit_game_button_button_down() -> void:
	get_tree().quit()


func _on_start_button_button_down() -> void:
	Game.initial_load()
	get_tree().change_scene_to_file("res://scenes/manager_setup/manager_setup_scene.tscn")


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/load_game/load_game_scene.tscn")
