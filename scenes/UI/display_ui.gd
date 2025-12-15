@tool
class_name DisplayUi
extends Control

var top_ui: TopUi
var bottom_ui: BottomUi


func _enter_tree() -> void:
	var label = Label.new()
	label.text = "test"
	add_child(label)
	print("test")
	bottom_ui = BottomUi.new()
	print(bottom_ui.anchor_bottom)
	print(bottom_ui.anchor_top)
	add_child(bottom_ui)
	top_ui = TopUi.new()
	print(top_ui.anchor_bottom)
	print(top_ui.anchor_top)
	add_child(top_ui)
