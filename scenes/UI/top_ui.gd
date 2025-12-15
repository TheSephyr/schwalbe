class_name TopUi
extends Control

@onready var week_value: Label = $VBoxContainer/WeekValue
@onready var current_club: Label = $VBoxContainer/CurrentClub


func _ready() -> void:
	EventBus.update_ui.connect(_on_update_ui)
	week_value.text = str(Game.current_week)
	current_club.text = Game.player_club.name


func _on_update_ui() -> void:
	week_value.text = str(Game.current_week)
