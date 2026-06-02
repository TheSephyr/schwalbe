@tool
class_name DisplayUi
extends Control

var top_ui: TopUi
var bottom_ui: BottomUi


func _enter_tree() -> void:
	bottom_ui = BottomUi.new()
	add_child(bottom_ui)
	top_ui = TopUi.new()
	add_child(top_ui)
