extends Control

@onready var player_list: VBoxContainer = $Content/VBox/Scroll/PlayerList
@onready var skill_picker: PanelContainer = $SkillPicker
@onready var skill_list: VBoxContainer = $SkillPicker/PickerMargin/PickerVBox/SkillScroll/SkillList
@onready var picker_title: Label = $SkillPicker/PickerMargin/PickerVBox/PickerHeader/PickerTitle

var _selected_player: Player = null


func _ready() -> void:
	_populate()


func _populate() -> void:
	for child in player_list.get_children():
		child.queue_free()
	for i: int in Game.player_club.players.size():
		player_list.add_child(_make_row(Game.player_club.players[i], i))


func _make_row(player: Player, index: int) -> Control:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.91, 0.9, 0.82, 1) if index % 2 == 0 else Color(0.86, 0.85, 0.75, 1)
	style.border_width_bottom = 1
	style.border_color = Color(0.7, 0.68, 0.58, 1)
	panel.add_theme_stylebox_override("panel", style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 8)
	margin.add_child(hbox)

	var name_lbl := Label.new()
	name_lbl.text = player.firstname + " " + player.lastname
	name_lbl.add_theme_font_size_override("font_size", 12)
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(name_lbl)

	var pos_lbl := Label.new()
	pos_lbl.text = player.position_label()
	pos_lbl.add_theme_font_size_override("font_size", 12)
	pos_lbl.custom_minimum_size = Vector2(40, 0)
	hbox.add_child(pos_lbl)

	var skill_lbl := Label.new()
	skill_lbl.text = _skill_name_for(player)
	skill_lbl.add_theme_font_size_override("font_size", 12)
	skill_lbl.custom_minimum_size = Vector2(120, 0)
	if player.training_skill != 0:
		skill_lbl.modulate = Color(0.18, 0.6, 0.18, 1.0)
	hbox.add_child(skill_lbl)

	var bar := ProgressBar.new()
	bar.min_value = 0.0
	bar.max_value = 1.0
	bar.value = player.training_progress
	bar.custom_minimum_size = Vector2(90, 18)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(bar)

	hbox.add_child(_make_skills_column(player))

	panel.gui_input.connect(_on_row_input.bind(player))
	return panel


func _make_skills_column(player: Player) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 1)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	var is_gk := player.position == "1"
	var labels: Dictionary = GoalkeeperSkillTypes.LABELS if is_gk else PlayerSkillTypes.LABELS
	var pos_skills: Array = player.gk_positive_skills if is_gk else player.positive_skills
	var neg_skills: Array = player.gk_negative_skills if is_gk else player.negative_skills

	if pos_skills.is_empty() and neg_skills.is_empty():
		var lbl := Label.new()
		lbl.text = "-"
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.modulate = Color(0.6, 0.6, 0.6, 1.0)
		vbox.add_child(lbl)
		return vbox

	if not pos_skills.is_empty():
		var parts := PackedStringArray()
		for s: int in pos_skills:
			parts.append(labels.get(s, str(s)))
		var lbl := Label.new()
		lbl.text = "+ " + ", ".join(parts)
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.modulate = Color(0.18, 0.6, 0.18, 1.0)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(lbl)

	if not neg_skills.is_empty():
		var parts := PackedStringArray()
		for s: int in neg_skills:
			parts.append(labels.get(s, str(s)))
		var lbl := Label.new()
		lbl.text = "- " + ", ".join(parts)
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.modulate = Color(0.75, 0.15, 0.15, 1.0)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(lbl)

	return vbox


func _on_row_input(event: InputEvent, player: Player) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_open_skill_picker(player)


func _skill_name_for(player: Player) -> String:
	if player.training_skill == 0:
		return "-"
	if player.position == "1":
		return GoalkeeperSkillTypes.LABELS.get(player.training_skill, "?")
	return PlayerSkillTypes.LABELS.get(player.training_skill, "?")


func _open_skill_picker(player: Player) -> void:
	_selected_player = player
	picker_title.text = player.firstname + " " + player.lastname
	for child in skill_list.get_children():
		child.queue_free()

	var skills: Array
	var labels: Dictionary
	if player.position == "1":
		skills = GoalkeeperSkillTypes.Skill.values()
		labels = GoalkeeperSkillTypes.LABELS
	else:
		skills = PlayerSkillTypes.Skill.values()
		labels = PlayerSkillTypes.LABELS

	for skill_val: int in skills:
		var already_has: bool
		if player.position == "1":
			already_has = player.gk_positive_skills.has(skill_val as GoalkeeperSkillTypes.Skill)
		else:
			already_has = player.positive_skills.has(skill_val as PlayerSkillTypes.Skill)
		if already_has:
			continue
		var btn := Button.new()
		btn.text = labels.get(skill_val, str(skill_val))
		btn.add_theme_font_size_override("font_size", 12)
		if player.training_skill == skill_val:
			btn.modulate = Color(0.18, 0.6, 0.18, 1.0)
		btn.pressed.connect(_select_skill.bind(skill_val))
		skill_list.add_child(btn)

	skill_picker.visible = true


func _select_skill(skill_val: int) -> void:
	if _selected_player == null:
		return
	_selected_player.training_skill = skill_val
	_selected_player.training_progress = 0.0
	skill_picker.visible = false
	_populate()


func _on_picker_close_pressed() -> void:
	skill_picker.visible = false
