extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
