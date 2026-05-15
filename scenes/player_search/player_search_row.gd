extends PanelContainer

var _player: Player
var _source_club: Club = null
var _popup: PopupMenu


func setup(player: Player, club_name: String) -> void:
	_player = player
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	if club_name != "Vereinslos":
		for club: Club in Game.first_division_clubs:
			if club.name == club_name:
				_source_club = club
				break

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 2)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 2)
	add_child(margin)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 4)
	margin.add_child(hbox)

	_add_lbl(hbox, player.lastname + ", " + player.firstname, true, 0)
	_add_lbl(hbox, club_name, true, 0)
	_add_lbl(hbox, player.position_label(), false, 44)
	_add_lbl(hbox, _age(player.birthdate), false, 40)
	_add_lbl(hbox, player.talent, false, 48)
	_add_lbl(hbox, player.currentAbility, false, 48)

	_popup = PopupMenu.new()
	_popup.add_item("Spieler Info", 0)
	_popup.add_item(_action_label(), 1)
	_popup.id_pressed.connect(_on_popup_id_pressed)
	add_child(_popup)

	gui_input.connect(_on_gui_input)


func _action_label() -> String:
	if _source_club == null:
		return "Vertragsverhandlung"
	if _source_club == Game.player_club:
		return "Vertragsverhandlung"
	var days_left := _days_until_contract_end(_player)
	if days_left <= GameConfig.PRECONTRACT_WINDOW_DAYS:
		return "Vorvertrag"
	return "Transferverhandlung"


func _add_lbl(parent: HBoxContainer, text: String, expand: bool, min_width: float) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 12)
	if expand:
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if min_width > 0:
		lbl.custom_minimum_size.x = min_width
	parent.add_child(lbl)


func _age(birthdate: String) -> String:
	var parts := birthdate.split(".")
	if parts.size() < 3:
		return "?"
	return str(Game.current_date.year - parts[2].to_int())


func _days_until_contract_end(player: Player) -> int:
	return Game.days_until_contract_end(player)


func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or not event.pressed:
		return
	if event.button_index == MOUSE_BUTTON_LEFT:
		GameState.selected_player = _player
		get_tree().change_scene_to_file("res://scenes/player/player_scene.tscn")
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		_popup.position = Vector2i(get_global_mouse_position())
		_popup.popup()


func _on_popup_id_pressed(id: int) -> void:
	GameState.selected_player = _player
	if id == 0:
		get_tree().change_scene_to_file("res://scenes/player/player_scene.tscn")
		return

	if _source_club == null:
		GameState.transfer_context = "free"
		GameState.transfer_source_club = null
		get_tree().change_scene_to_file("res://scenes/contract/contract_scene.tscn")
	elif _source_club == Game.player_club:
		GameState.transfer_context = "renewal"
		GameState.transfer_source_club = null
		get_tree().change_scene_to_file("res://scenes/contract/contract_scene.tscn")
	else:
		var days_left := _days_until_contract_end(_player)
		GameState.transfer_source_club = _source_club
		if days_left <= GameConfig.PRECONTRACT_WINDOW_DAYS:
			GameState.transfer_context = "precontract"
			get_tree().change_scene_to_file("res://scenes/contract/contract_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/transfer/transfer_scene.tscn")
