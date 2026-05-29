extends Control


func _on_sponsors_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/sponsor_scene.tscn")


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/preseason_scene.tscn")
