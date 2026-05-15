extends Control

@onready var save_list: VBoxContainer = $Content/MainHBox/LeftPanel/SaveScroll/SaveList
@onready var save_name_edit: LineEdit = $Content/MainHBox/RightPanel/FormMargin/FormVBox/SaveNameEdit
@onready var save_button: Button = $Content/MainHBox/RightPanel/FormMargin/FormVBox/SaveButton
@onready var status_label: Label = $Content/MainHBox/RightPanel/FormMargin/FormVBox/StatusLabel

var _style_selected: StyleBoxFlat
var _style_normal: StyleBoxFlat
var _selected_btn: Button = null


func _ready() -> void:
	_style_normal = StyleBoxFlat.new()
	_style_normal.bg_color = Color(0.91, 0.9, 0.82, 1)
	_style_normal.set_border_width_all(1)
	_style_normal.border_color = Color(0.5, 0.48, 0.38, 1)
	_style_normal.set_content_margin_all(4)

	_style_selected = StyleBoxFlat.new()
	_style_selected.bg_color = Color(0.96, 0.8, 0.0, 1)
	_style_selected.set_border_width_all(1)
	_style_selected.border_color = Color(0.6, 0.5, 0.0, 1)
	_style_selected.set_content_margin_all(4)

	save_button.disabled = true
	save_name_edit.text_changed.connect(_on_name_changed)
	_populate_saves()


func _populate_saves() -> void:
	for child in save_list.get_children():
		child.queue_free()
	_selected_btn = null

	for save_name: String in Game.list_saves():
		var btn := Button.new()
		btn.text = save_name
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_on_save_selected.bind(save_name, btn))
		save_list.add_child(btn)


func _on_save_selected(save_name: String, btn: Button) -> void:
	if _selected_btn != null:
		_selected_btn.modulate = Color.WHITE
	_selected_btn = btn
	btn.modulate = Color(0.96, 0.8, 0.0, 1)
	save_name_edit.text = save_name
	save_button.disabled = false
	status_label.text = ""


func _on_name_changed(text: String) -> void:
	save_button.disabled = text.strip_edges().is_empty()
	status_label.text = ""
	if _selected_btn != null and text != _selected_btn.text:
		_selected_btn.modulate = Color.WHITE
		_selected_btn = null


func _on_save_pressed() -> void:
	var save_name := save_name_edit.text.strip_edges()
	Game.save_game(save_name)
	status_label.text = 'Gespeichert: "%s"' % save_name
	_populate_saves()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
