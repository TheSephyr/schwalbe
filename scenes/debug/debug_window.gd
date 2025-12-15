extends Window

@onready var scene_name: Label = $HBoxContainer/SceneName


func _ready() -> void:
	scene_name.text = get_tree().current_scene.name


func _on_close_requested() -> void:
	queue_free()
