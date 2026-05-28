extends Control

@onready var list_box: VBoxContainer = $Content/ScrollContainer/ListBox

var _row_index: int = 0


func _ready() -> void:
	_add_section("Manager")
	var manager: Manager = Game.player_club.manager
	if manager != null:
		_add_row(manager, _club_for_manager(manager))

	_add_section("Trainer")
	var trainer: Trainer = Game.player_club.trainer
	if trainer != null:
		_add_row(trainer, _club_for_trainer(trainer))

	_add_section("Reporter")
	for r: Reporter in Game.reporters:
		_add_row(r, r.broadcaster)

	_add_section("Schiedsrichter")
	for r: Referee in Game.referees:
		_add_row(r, "")

	_add_section("Promis")
	for c: Celebrity in Game.celebrities:
		_add_row(c, "")


func _add_section(title: String) -> void:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.96, 0.8, 0.0, 1)
	style.content_margin_left = 6.0
	style.content_margin_top = 2.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 2.0
	panel.add_theme_stylebox_override("panel", style)
	var lbl := Label.new()
	lbl.text = title
	lbl.add_theme_font_size_override("font_size", 12)
	panel.add_child(lbl)
	list_box.add_child(panel)


func _add_row(person: RefCounted, subtitle: String) -> void:
	var container := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.91, 0.9, 0.82, 1) if _row_index % 2 == 0 else Color(0.85, 0.84, 0.74, 1)
	container.add_theme_stylebox_override("panel", style)
	container.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 3)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 3)
	container.add_child(margin)

	var hbox := HBoxContainer.new()
	margin.add_child(hbox)

	var name_lbl := Label.new()
	name_lbl.text = _full_name(person)
	name_lbl.add_theme_font_size_override("font_size", 12)
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(name_lbl)

	if subtitle != "":
		var sub_lbl := Label.new()
		sub_lbl.text = subtitle
		sub_lbl.add_theme_font_size_override("font_size", 11)
		sub_lbl.modulate = Color(0.45, 0.45, 0.45, 1.0)
		hbox.add_child(sub_lbl)

	container.gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			GameState.selected_person = person
			get_tree().change_scene_to_file("res://scenes/person/person_scene.tscn")
	)

	list_box.add_child(container)
	_row_index += 1


func _full_name(person: RefCounted) -> String:
	if person is Manager: return (person as Manager).full_name()
	if person is Trainer: return (person as Trainer).full_name()
	if person is Referee: return (person as Referee).full_name()
	if person is Reporter: return (person as Reporter).full_name()
	if person is Celebrity: return (person as Celebrity).full_name()
	return "?"


func _club_for_manager(m: Manager) -> String:
	for club: Club in Game.all_clubs:
		if club.manager == m:
			return club.name
	return ""


func _club_for_trainer(t: Trainer) -> String:
	for club: Club in Game.all_clubs:
		if club.trainer == t:
			return club.name
	return ""
