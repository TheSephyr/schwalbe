extends Node

signal next_matchday

signal update_ui


func emit_next_matchday() -> void:
	next_matchday.emit()

func emit_update_ui() -> void:
	update_ui.emit()
