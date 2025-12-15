class_name TopUi
extends Control

@onready var week_value: Label = $VBoxContainer/WeekValue


func _ready() -> void:
	EventBus.update_ui.connect(_on_update_ui)
	week_value.text = str(Game.current_week)


func _on_update_ui() -> void:
	week_value.text = str(Game.current_week)
