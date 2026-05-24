extends Control

@onready var player_list: VBoxContainer = $Margin/VBox/Scroll/PlayerList

var _pending_changes: Array[Dictionary] = []


func _ready() -> void:
	_calculate_and_display()


func _calculate_and_display() -> void:
	for player: Player in Game.player_club.players:
		var delta: int = _calculate_delta(player)
		var old_ability: int = player.currentAbility.to_int()
		var new_ability: int = clampi(old_ability + delta, 1, 100)
		_pending_changes.append({"player": player, "delta": delta, "new_ability": new_ability})
		_add_row(player, old_ability, new_ability, delta)


func _add_row(player: Player, old_ability: int, new_ability: int, delta: int) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)

	var name_lbl := Label.new()
	name_lbl.text = player.lastname + ", " + player.firstname
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", 13)
	row.add_child(name_lbl)

	var games_lbl := Label.new()
	games_lbl.text = "(%d Sp.)" % player.matches_played
	games_lbl.custom_minimum_size.x = 56
	games_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	games_lbl.add_theme_font_size_override("font_size", 12)
	games_lbl.modulate = Color(0.7, 0.7, 0.7, 1.0)
	row.add_child(games_lbl)

	var ability_lbl := Label.new()
	ability_lbl.text = "%d → %d" % [old_ability, new_ability]
	ability_lbl.custom_minimum_size.x = 70
	ability_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	ability_lbl.add_theme_font_size_override("font_size", 13)
	row.add_child(ability_lbl)

	var delta_lbl := Label.new()
	var sign: String = "+" if delta >= 0 else ""
	delta_lbl.text = sign + str(delta)
	delta_lbl.custom_minimum_size.x = 36
	delta_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	delta_lbl.add_theme_font_size_override("font_size", 13)
	if delta > 0:
		delta_lbl.modulate = Color(0.2, 0.9, 0.2, 1.0)
	elif delta < 0:
		delta_lbl.modulate = Color(0.9, 0.2, 0.2, 1.0)
	else:
		delta_lbl.modulate = Color(0.6, 0.6, 0.6, 1.0)
	row.add_child(delta_lbl)

	player_list.add_child(row)


func _calculate_delta(player: Player) -> int:
	var parts: PackedStringArray = player.birthdate.split(".")
	var birth_year: int = int(parts[2])
	var birth_month: int = int(parts[1])
	var birth_day: int = int(parts[0])
	var age: int = Game.current_date.year - birth_year
	if Game.current_date.month < birth_month or (Game.current_date.month == birth_month and Game.current_date.day < birth_day):
		age -= 1

	var talent: float = float(player.talent.to_int()) / 100.0
	var games: int = player.matches_played

	var age_factor: float
	if age <= 19:
		age_factor = 2.0
	elif age <= 22:
		age_factor = 1.5
	elif age <= 25:
		age_factor = 0.8
	elif age <= 28:
		age_factor = 0.2
	elif age <= 31:
		age_factor = -0.6
	else:
		age_factor = -1.2

	# 20% base effect even for benched players, scales to 100% at full games played
	var games_factor: float = 0.2 + 0.8 * float(mini(games, GameConfig.WINTER_BREAK_AFTER_MD)) / float(GameConfig.WINTER_BREAK_AFTER_MD)
	var raw: float = age_factor * talent * games_factor * 5.0
	return clampi(int(round(raw)), -5, 5)


func _on_continue_pressed() -> void:
	var year: int = Game.current_season.start_year
	var label: String = "Hinrunde %d/%02d" % [year, (year + 1) % 100]
	for entry: Dictionary in _pending_changes:
		var p: Player = entry["player"]
		p.currentAbility = str(entry["new_ability"])
		p.ability_history.append({"label": label, "ability": entry["new_ability"]})
	Game.save_game("Autosave")
	get_tree().change_scene_to_file("res://scenes/club_overview.tscn")
