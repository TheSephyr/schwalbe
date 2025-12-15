extends Node

const LoadedDebugWindow: Resource = preload("res://scenes/debug/debug_window.tscn")

#show_debug_window()
func _ready() -> void:
	print("golobal is ready")

func show_debug_window() -> void:
	var debug_window = LoadedDebugWindow.instantiate()
	get_tree().root.add_child(debug_window)
	print("test")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("show_debug_window"):
		show_debug_window()
