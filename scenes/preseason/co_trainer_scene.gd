extends Control

@onready var list_box: VBoxContainer = $Content/OuterVBox/ScrollContainer/ListBox

var _row_index: int = 0

static var REPUTATION_LABELS: Dictionary = {
	TrainerReputationTypes.Reputation.BUDDY: "Kumpeltyp",
	TrainerReputationTypes.Reputation.FUNNY_GUY: "Lustiger Geselle",
	TrainerReputationTypes.Reputation.MOTIVATOR: "Motivationskünstler",
	TrainerReputationTypes.Reputation.PR_MAN: "PR-Mann",
	TrainerReputationTypes.Reputation.HARD_DRIVER: "Schleifer",
	TrainerReputationTypes.Reputation.SCIENTIST: "Wissenschaftler",
	TrainerReputationTypes.Reputation.NONE: "—",
}


func _ready() -> void:
	var trainers: Array[Trainer] = _collect_trainers()
	trainers.sort_custom(func(a: Trainer, b: Trainer) -> bool:
		return a.competence > b.competence
	)
	for trainer: Trainer in trainers:
		_add_row(trainer)


func _collect_trainers() -> Array[Trainer]:
	var result: Array[Trainer] = []
	for club: Club in Game.all_clubs:
		if club.trainer != null:
			result.append(club.trainer)
	return result


func _add_row(trainer: Trainer) -> void:
	var is_current: bool = Game.player_club.co_trainer == trainer

	var container := PanelContainer.new()
	var style := StyleBoxFlat.new()
	if is_current:
		style.bg_color = Color(0.84, 0.93, 0.82, 1)
		style.border_width_left = 2
		style.border_width_top = 2
		style.border_width_right = 2
		style.border_width_bottom = 2
		style.border_color = Color(0.25, 0.55, 0.25, 1)
	else:
		style.bg_color = Color(0.91, 0.9, 0.82, 1) if _row_index % 2 == 0 else Color(0.85, 0.84, 0.74, 1)
	container.add_theme_stylebox_override("panel", style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 5)
	container.add_child(margin)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	margin.add_child(hbox)

	var name_lbl := Label.new()
	name_lbl.text = trainer.full_name()
	name_lbl.add_theme_font_size_override("font_size", 13)
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(name_lbl)

	var club_lbl := Label.new()
	club_lbl.text = _club_for_trainer(trainer)
	club_lbl.add_theme_font_size_override("font_size", 12)
	club_lbl.modulate = Color(0.45, 0.45, 0.45, 1.0)
	club_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(club_lbl)

	var rep_lbl := Label.new()
	rep_lbl.text = REPUTATION_LABELS.get(trainer.reputation, "—")
	rep_lbl.add_theme_font_size_override("font_size", 12)
	rep_lbl.modulate = Color(0.45, 0.45, 0.45, 1.0)
	rep_lbl.custom_minimum_size.x = 140
	hbox.add_child(rep_lbl)

	var comp_lbl := Label.new()
	comp_lbl.text = "Kompetenz: %d" % trainer.competence
	comp_lbl.add_theme_font_size_override("font_size", 12)
	comp_lbl.custom_minimum_size.x = 110
	hbox.add_child(comp_lbl)

	var btn := Button.new()
	btn.text = "Verpflichten" if not is_current else "✓ Verpflichtet"
	btn.add_theme_font_size_override("font_size", 12)
	btn.disabled = is_current
	btn.pressed.connect(func() -> void:
		Game.player_club.co_trainer = trainer
		get_tree().change_scene_to_file("res://scenes/preseason/calculation_scene.tscn")
	)
	hbox.add_child(btn)

	list_box.add_child(container)
	_row_index += 1


func _club_for_trainer(trainer: Trainer) -> String:
	for club: Club in Game.all_clubs:
		if club.trainer == trainer:
			return club.name
	return ""


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/calculation_scene.tscn")
