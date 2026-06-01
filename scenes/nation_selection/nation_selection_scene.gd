extends Control

const DATA_DIR := "res://dbfiles/Data.a3/"

var _file_entries: Dictionary = {}  # path: String → CheckBox

@onready var file_list: VBoxContainer = $CenterContainer/ContentVBox/SelectionPanel/Margin/VBox/FileListVBox
@onready var selected_label: Label = $CenterContainer/ContentVBox/SelectionPanel/Margin/VBox/SelectedFileLabel
@onready var file_dialog: FileDialog = $FileDialog


func _ready() -> void:
	var files := DirAccess.get_files_at(DATA_DIR)
	files.sort()
	for file_name: String in files:
		if not file_name.begins_with("Land") or not file_name.ends_with(".sav"):
			continue
		_add_entry(DATA_DIR + file_name, file_name, true)
	file_dialog.add_filter("*.sav", "Nation-Dateien")
	selected_label.visible = false


func _add_entry(path: String, label: String, checked: bool) -> void:
	if _file_entries.has(path):
		return
	var cb := CheckBox.new()
	cb.text = label
	cb.button_pressed = checked
	file_list.add_child(cb)
	_file_entries[path] = cb


func _on_browse_pressed() -> void:
	file_dialog.popup_centered_ratio(0.9)


func _on_file_dialog_dir_selected(dir: String) -> void:
	var added := 0
	var files := DirAccess.get_files_at(dir)
	files.sort()
	for file_name: String in files:
		if not file_name.begins_with("Land") or not file_name.ends_with(".sav"):
			continue
		_add_entry(dir.path_join(file_name), file_name, true)
		added += 1
	if added > 0:
		selected_label.text = "Hinzugefügt: %d Dateien aus %s" % [added, dir.get_file()]
		selected_label.visible = true


func _on_weiter_pressed() -> void:
	var selected: Array[String] = []
	for path: String in _file_entries:
		if (_file_entries[path] as CheckBox).button_pressed:
			selected.append(path)
	if selected.is_empty():
		return
	GameState.selected_nation_files = selected
	get_tree().change_scene_to_file("res://scenes/loading/loading_scene.tscn")
