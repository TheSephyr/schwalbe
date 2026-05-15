extends PanelContainer

var week_index: int = 0
var assigned_type: int = 0
var _training_label: Label


func setup(index: int, week_start: Date, type: int, matchday_num: int = 0) -> void:
	week_index = index
	assigned_type = type

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 3)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 3)
	add_child(margin)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 8)
	margin.add_child(hbox)

	var week_lbl := Label.new()
	week_lbl.text = "Woche %d" % (index + 1)
	week_lbl.custom_minimum_size.x = 60
	week_lbl.add_theme_font_size_override("font_size", 12)
	hbox.add_child(week_lbl)

	var date_lbl := Label.new()
	date_lbl.text = week_start._to_string()
	date_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	date_lbl.add_theme_font_size_override("font_size", 12)
	hbox.add_child(date_lbl)

	var md_lbl := Label.new()
	md_lbl.text = "Sp. %d" % matchday_num if matchday_num > 0 else ""
	md_lbl.custom_minimum_size.x = 44
	md_lbl.add_theme_font_size_override("font_size", 11)
	md_lbl.modulate = Color(0.3, 0.3, 0.8, 1)
	hbox.add_child(md_lbl)

	_training_label = Label.new()
	_training_label.text = _type_label(assigned_type)
	_training_label.custom_minimum_size.x = 150
	_training_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_training_label.add_theme_font_size_override("font_size", 12)
	hbox.add_child(_training_label)


func update_type(type: int) -> void:
	assigned_type = type
	_training_label.text = _type_label(type)


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("training_type")


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	assigned_type = int(data["training_type"])
	Game.training_plan[week_index] = assigned_type
	_training_label.text = _type_label(assigned_type)


func _type_label(type: int) -> String:
	match type:
		GameConfig.TRAINING_TYPE_CONDITION:
			return "Konditionstraining"
		GameConfig.TRAINING_TYPE_REGEN:
			return "Regeneration"
	return "—"
