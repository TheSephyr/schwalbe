extends Control

@onready var save_list: VBoxContainer = $Content/MainHBox/RightPanel/ScrollContainer/SaveList
@onready var no_saves_label: Label = $Content/MainHBox/RightPanel/NoSavesLabel

var _style_panel: StyleBoxFlat
var _style_header: StyleBoxFlat


func _ready() -> void:
	_style_panel = StyleBoxFlat.new()
	_style_panel.bg_color = Color(0.91, 0.9, 0.82, 1)
	_style_panel.set_border_width_all(1)
	_style_panel.border_color = Color(0.5, 0.48, 0.38, 1)
	_style_panel.set_content_margin_all(8)

	_style_header = StyleBoxFlat.new()
	_style_header.bg_color = Color(0.96, 0.8, 0.0, 1)
	_style_header.set_content_margin_all(4)

	var saves := Game.list_saves()
	if saves.is_empty():
		no_saves_label.visible = true
	else:
		no_saves_label.visible = false
		for save_name: String in saves:
			save_list.add_child(_build_entry(save_name))


func _read_meta(save_name: String) -> Dictionary:
	var path := "user://saves/" + save_name + ".json"
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK:
		return {}
	return json.get_data()


func _build_entry(save_name: String) -> Control:
	var meta := _read_meta(save_name)

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style_panel)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	panel.add_child(vbox)

	# Title row: name + load button side by side
	var title_row := HBoxContainer.new()
	vbox.add_child(title_row)

	var name_label := Label.new()
	name_label.text = save_name
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 13)
	title_row.add_child(name_label)

	var load_btn := Button.new()
	load_btn.text = "Laden"
	load_btn.pressed.connect(_load_save.bind(save_name))
	title_row.add_child(load_btn)

	# Info rows
	var club_name: String = meta.get("player_club_name", "–")
	var saved_at: String = meta.get("saved_at", "–")
	var game_day: int = int(meta.get("current_date_day", 0))
	var game_month: int = int(meta.get("current_date_month", 0))
	var game_year: int = int(meta.get("current_date_year", 0))
	var game_date := "%02d.%02d.%04d" % [game_day, game_month, game_year]

	vbox.add_child(_info_row("Verein", club_name))
	vbox.add_child(_info_row("Spielstand", game_date))
	vbox.add_child(_info_row("Gespeichert", saved_at))

	return panel


func _info_row(label_text: String, value_text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)

	var lbl := Label.new()
	lbl.text = label_text + ":"
	lbl.custom_minimum_size = Vector2(90, 0)
	lbl.add_theme_font_size_override("font_size", 11)
	row.add_child(lbl)

	var val := Label.new()
	val.text = value_text
	val.add_theme_font_size_override("font_size", 11)
	row.add_child(val)

	return row


func _load_save(save_name: String) -> void:
	Game.load_game(save_name)
	get_tree().change_scene_to_file("res://scenes/club_overview.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
