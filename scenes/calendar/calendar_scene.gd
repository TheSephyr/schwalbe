class_name CalendarScene
extends Control

const MONTH_NAMES: Array[String] = [
	"Januar", "Februar", "März", "April", "Mai", "Juni",
	"Juli", "August", "September", "Oktober", "November", "Dezember"
]
const WEEKDAY_NAMES: Array[String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]

var display_month: int
var display_year: int

@onready var month_label: Label = $Content/HeaderPanel/Header/MonthLabel
@onready var days_grid: GridContainer = $Content/DaysGrid


func _ready() -> void:
	display_month = Game.current_date.month
	display_year = Game.current_date.year
	_build_calendar()


func _build_calendar() -> void:
	month_label.text = MONTH_NAMES[display_month - 1] + " " + str(display_year)

	while days_grid.get_child_count() > 0:
		days_grid.get_child(0).free()

	for wday: String in WEEKDAY_NAMES:
		var lbl := Label.new()
		lbl.text = wday
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		days_grid.add_child(lbl)

	var match_map: Dictionary = {}
	for md: Matchday in Game.player_season().matchdays:
		if md.date.month == display_month and md.date.year == display_year:
			for m: Match in md.matches:
				if m.homeTeam == Game.player_club or m.awayTeam == Game.player_club:
					match_map[md.date.day] = m
					break

	var other_md_days: Dictionary = {}
	for season: Season in Game.seasons:
		if season == Game.player_season():
			continue
		for md: Matchday in season.matchdays:
			if md.date.month == display_month and md.date.year == display_year:
				if not match_map.has(md.date.day):
					other_md_days[md.date.day] = true

	var first_weekday: int = _weekday(1, display_month, display_year)
	var days_in_month: int = Date._days_in_month(display_month, display_year)
	var is_current_month: bool = (
		display_month == Game.current_date.month
		and display_year == Game.current_date.year
	)

	for _i: int in first_weekday:
		days_grid.add_child(_make_filler())

	for day: int in range(1, days_in_month + 1):
		var m: Match = match_map.get(day, null)
		var is_today: bool = is_current_month and day == Game.current_date.day
		days_grid.add_child(_make_day_cell(day, m, is_today, other_md_days.has(day)))


func _make_filler() -> Control:
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 44)
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return spacer


func _make_day_cell(day: int, m: Match, is_today: bool, is_other_md: bool = false) -> Control:
	var cell := PanelContainer.new()
	cell.custom_minimum_size = Vector2(0, 44)
	cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var style := StyleBoxFlat.new()
	style.set_border_width_all(1)
	style.border_color = Color(0.5, 0.48, 0.38, 1)
	style.set_content_margin_all(2)
	if is_today:
		style.bg_color = Color(0.35, 0.62, 0.38, 1)
	elif m != null:
		style.bg_color = Color(0.96, 0.8, 0.0, 1)
	elif is_other_md:
		style.bg_color = Color(0.7, 0.7, 0.6, 1)
	else:
		style.bg_color = Color(0.91, 0.9, 0.82, 1)
	cell.add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 1)

	var day_lbl := Label.new()
	day_lbl.text = str(day)
	day_lbl.add_theme_font_size_override("font_size", 11)
	day_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	vbox.add_child(day_lbl)

	if m != null:
		var info_lbl := Label.new()
		if m.played:
			if m.homeTeam == Game.player_club:
				info_lbl.text = str(m.scoreHome) + ":" + str(m.scoreAway)
			else:
				info_lbl.text = str(m.scoreAway) + ":" + str(m.scoreHome)
		else:
			if m.homeTeam == Game.player_club:
				info_lbl.text = "H:" + _short_name(m.awayTeam.name)
			else:
				info_lbl.text = "A:" + _short_name(m.homeTeam.name)
		info_lbl.add_theme_font_size_override("font_size", 9)
		info_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		info_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(info_lbl)

	cell.add_child(vbox)
	return cell


func _short_name(full_name: String) -> String:
	for part: String in full_name.split(" "):
		if part.length() > 2 and not part[0].is_valid_int():
			return part.left(8)
	return full_name.left(8)


func _weekday(day: int, month: int, year: int) -> int:
	# Zeller's congruence, returns 0 = Monday … 6 = Sunday
	var m: int = month
	var y: int = year
	if m < 3:
		m += 12
		y -= 1
	var k: int = y % 100
	var j: int = y / 100
	var h: int = (day + (13 * (m + 1)) / 5 + k + k / 4 + j / 4 - 2 * j) % 7
	if h < 0:
		h += 7
	return (h + 5) % 7


func _on_prev_button_pressed() -> void:
	display_month -= 1
	if display_month < 1:
		display_month = 12
		display_year -= 1
	_build_calendar()


func _on_next_button_pressed() -> void:
	display_month += 1
	if display_month > 12:
		display_month = 1
		display_year += 1
	_build_calendar()
