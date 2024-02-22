extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_game_button_button_down():
	print("quit")
	get_tree().quit()


func _on_start_button_button_down():
	get_tree().change_scene_to_file("res://scenes/load_nation.tscn")
	pass # Replace with function body.
