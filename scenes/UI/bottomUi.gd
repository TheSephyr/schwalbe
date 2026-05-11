class_name BottomUi
extends Control


func _on_matchday_button_button_down():
	get_tree().change_scene_to_file("res://match/matchday.tscn")


func _on_table_button_button_down():
	get_tree().change_scene_to_file("res://scenes/table/table_scene.tscn")


func _on_line_up_button_down():
	get_tree().change_scene_to_file("res://scenes/lineup/lineUp.tscn")


func _on_club_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/club/club.tscn")


func _on_balance_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/balance/balance_scene.tscn")


func _on_next_button_button_up() -> void:
	EventBus.emit_next()
