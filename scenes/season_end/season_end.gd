class_name SeasonEndScene
extends Control

@onready var season_title: Label = %SeasonTitle
@onready var champion_name: Label = %ChampionName
@onready var champion_stats: Label = %ChampionStats
@onready var player_result: Label = %PlayerResult
@onready var table_rows: VBoxContainer = %TableRows


func _ready() -> void:
	var season := Game.player_season()
	var standings := season.table.teamStandings
	var champion := standings[0]
	var player_standing := season.table.findByTeam(Game.player_club)

	var start_year: int = season.matchdays[0].date.year
	season_title.text = "Saisonende %d/%d" % [start_year, (start_year + 1) % 100]

	champion_name.text = champion.team.name
	champion_stats.text = (
		"%d Pkt  |  %dS %dU %dN  |  %d:%d Tore" % [
			champion.points,
			champion.wins, champion.draws, champion.losses,
			champion.goalsFor, champion.goalsAgainst
		]
	)

	var pos: int = player_standing.currentPosition
	if pos == 1:
		player_result.text = "Platz 1 — Meister! Herzlichen Glueckwunsch!"
	elif pos <= 3:
		player_result.text = "Platz %d — Starke Saison!" % pos
	elif pos <= 6:
		player_result.text = "Platz %d — Gute Saison." % pos
	elif pos <= 15:
		player_result.text = "Platz %d — Ausbaufaehige Saison." % pos
	else:
		player_result.text = "Platz %d — Abstieg droht!" % pos

	for standing: TeamStanding in standings:
		table_rows.add_child(_make_row(standing))


func _make_row(s: TeamStanding) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)

	var is_champion := s.currentPosition == 1
	var is_player_club := s.team == Game.player_club
	var color: Color
	if is_champion:
		color = Color(0.804, 0.706, 0.29, 1)
	elif is_player_club:
		color = Color(0.35, 0.62, 0.38, 1)
	else:
		color = Color(0.2, 0.2, 0.2, 1)

	_add_fixed(row, str(s.currentPosition) + ".", 24, color)
	_add_expand(row, s.team.name, color)
	_add_fixed(row, str(s.matches), 22, color)
	_add_fixed(row, str(s.wins), 20, color)
	_add_fixed(row, str(s.draws), 20, color)
	_add_fixed(row, str(s.losses), 20, color)
	_add_fixed(row, "%d:%d" % [s.goalsFor, s.goalsAgainst], 48, color)
	_add_fixed(row, str(s.points), 28, color)
	return row


func _add_fixed(row: HBoxContainer, text: String, min_width: int, color: Color) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.custom_minimum_size = Vector2(min_width, 0)
	lbl.add_theme_font_size_override("font_size", 11)
	lbl.add_theme_color_override("font_color", color)
	row.add_child(lbl)


func _add_expand(row: HBoxContainer, text: String, color: Color) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 11)
	lbl.add_theme_color_override("font_color", color)
	row.add_child(lbl)


func _on_new_season_pressed() -> void:
	Game.start_new_season()
	get_tree().change_scene_to_file("res://scenes/club/club.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
