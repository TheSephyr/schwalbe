extends Control

@onready var left_content: VBoxContainer = $Content/MainHBox/LeftPanel/LeftMargin/LeftContent
@onready var right_content: VBoxContainer = $Content/MainHBox/RightPanel/RightMargin/RightContent


func _ready() -> void:
	var club := Game.player_club
	var season := Game.current_season
	var today := Game.current_date

	var season_start := Date.new(1, 7, season.start_year)
	var season_end := Date.new(30, 6, season.start_year + 1)
	var total_days := season_start.days_until(season_end)
	var days_elapsed := season_start.days_until(today)
	var days_remaining := today.days_until(season_end)

	var total_matchdays := season.matchdays.size()
	var played_matchdays := 0
	for md: Matchday in season.matchdays:
		if md.played:
			played_matchdays += 1
	var remaining_matchdays := total_matchdays - played_matchdays

	# Wages
	var daily_wage := club.total_daily_wages()
	var wages_total := daily_wage * total_days
	var wages_paid := daily_wage * days_elapsed
	var wages_remaining := daily_wage * days_remaining

	# Appearance bonuses
	var auflauf_paid := 0
	for player: Player in club.players:
		auflauf_paid += player.matches_played * player.auflauf_praemie

	var auflauf_per_matchday := 0
	for player: Player in club.currentLineUp:
		auflauf_per_matchday += player.auflauf_praemie

	var auflauf_remaining := auflauf_per_matchday * remaining_matchdays
	var auflauf_total := auflauf_paid + auflauf_remaining

	# Goal bonuses (rate only — goals can't be projected)
	var tor_per_goal := 0
	for player: Player in club.currentLineUp:
		tor_per_goal += player.tor_praemie

	# --- Left panel: whole season ---
	_add_info(left_content, "Spieltage", "%d von %d" % [played_matchdays, total_matchdays])
	_add_info(left_content, "Tage", "%d (Saison gesamt)" % total_days)
	_add_separator(left_content)
	_add_row(left_content, "Gehalt", _fmt(wages_total))
	_add_row(left_content, "Auflaufprämien", _fmt(auflauf_total))
	_add_row(left_content, "Torprämien", "%s / Tor" % _fmt(tor_per_goal))
	_add_separator(left_content)
	_add_row(left_content, "Gesamt", _fmt(wages_total + auflauf_total), true)

	# --- Right panel: rest of season ---
	_add_info(right_content, "Verbleibende Spieltage", str(remaining_matchdays))
	_add_info(right_content, "Verbleibende Tage", str(days_remaining))
	_add_separator(right_content)
	_add_row(right_content, "Gehalt", _fmt(wages_remaining))
	_add_row(right_content, "Auflaufprämien", _fmt(auflauf_remaining))
	_add_row(right_content, "Torprämien", "%s / Tor" % _fmt(tor_per_goal))
	_add_separator(right_content)
	_add_row(right_content, "Gesamt", _fmt(wages_remaining + auflauf_remaining), true)


func _add_info(parent: VBoxContainer, label_text: String, value_text: String) -> void:
	var row := HBoxContainer.new()
	var lbl := Label.new()
	lbl.text = label_text
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 11)
	var val := Label.new()
	val.text = value_text
	val.add_theme_font_size_override("font_size", 11)
	row.add_child(lbl)
	row.add_child(val)
	parent.add_child(row)


func _add_row(parent: VBoxContainer, label_text: String, value_text: String, bold: bool = false) -> void:
	var row := HBoxContainer.new()
	var lbl := Label.new()
	lbl.text = label_text
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 12)
	var val := Label.new()
	val.text = value_text
	val.add_theme_font_size_override("font_size", 12)
	if bold:
		lbl.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1, 1))
		val.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1, 1))
	row.add_child(lbl)
	row.add_child(val)
	parent.add_child(row)


func _add_separator(parent: VBoxContainer) -> void:
	parent.add_child(HSeparator.new())


func _fmt(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio DM" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d DM" % [amount / 1000, amount % 1000]
	return "%d DM" % amount
