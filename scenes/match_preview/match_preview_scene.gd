extends Control

@onready var title_label: Label = $Content/TitlePanel/TitleLabel
@onready var home_label: Label = $Content/MatchPanel/MatchMargin/MatchHBox/HomeLabel
@onready var away_label: Label = $Content/MatchPanel/MatchMargin/MatchHBox/AwayLabel
@onready var attendance_label: Label = $Content/AttendancePanel/AttendanceMargin/AttendanceLabel
@onready var home_lineup_box: VBoxContainer = $Content/LineupsPanel/LineupsMargin/LineupsHBox/HomeLineup
@onready var away_lineup_box: VBoxContainer = $Content/LineupsPanel/LineupsMargin/LineupsHBox/AwayLineup
@onready var home_header: Label = $Content/LineupsPanel/LineupsMargin/LineupsHBox/HomeLineup/HomeHeader
@onready var away_header: Label = $Content/LineupsPanel/LineupsMargin/LineupsHBox/AwayLineup/AwayHeader


func _ready() -> void:
	var matchday := Game.player_season().get_current_matchday()
	title_label.text = "Spielvorschau – Spieltag %d" % matchday.matchdayNumber

	var player_match := _find_player_match(matchday)
	if player_match == null:
		return

	var home := player_match.homeTeam
	var away := player_match.awayTeam

	home_label.text = home.name
	away_label.text = away.name
	home_header.text = home.name
	away_header.text = away.name

	var attendance := _calc_attendance(home)
	var attendance_text := "Zuschauer: %s" % _fmt(attendance)
	if home == Game.player_club and home.stadium != null:
		var revenue := attendance * home.stadium.ticket_price
		attendance_text += "   |   Einnahmen: %s DM" % _fmt(revenue)
		Game.player_club.money += revenue
	attendance_label.text = attendance_text

	_fill_lineup(home_lineup_box, home.currentLineUp, home_header)
	_fill_lineup(away_lineup_box, away.currentLineUp, away_header)


func _find_player_match(matchday: Matchday) -> Match:
	for m: Match in matchday.matches:
		if m.homeTeam == Game.player_club or m.awayTeam == Game.player_club:
			return m
	return null


func _calc_attendance(home_club: Club) -> int:
	var capacity := home_club.stadium.total() if home_club.stadium != null else 20000
	if capacity <= 0:
		capacity = 20000
	return int(capacity * randf_range(0.65, 0.98))


func _fill_lineup(box: VBoxContainer, lineup: Array[Player], header: Label) -> void:
	# Remove all children except the header
	for child in box.get_children():
		if child != header:
			child.queue_free()

	for player: Player in lineup:
		var row := HBoxContainer.new()
		var pos_lbl := Label.new()
		pos_lbl.text = player.position_label()
		pos_lbl.custom_minimum_size = Vector2(40, 0)
		pos_lbl.add_theme_font_size_override("font_size", 11)
		var name_lbl := Label.new()
		name_lbl.text = player.lastname
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.add_theme_font_size_override("font_size", 11)
		row.add_child(pos_lbl)
		row.add_child(name_lbl)
		box.add_child(row)


func _fmt(n: int) -> String:
	return "%d.%03d" % [n / 1000, n % 1000] if n >= 1000 else str(n)


func _on_simulate_pressed() -> void:
	Game.confirm_matchday_simulation()
