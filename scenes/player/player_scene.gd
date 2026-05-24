extends Control

var player: Player
var _club_players: Array[Player] = []
var _player_index: int = 0

@onready var full_name: Label = $Content/VBox/Header/HMargin/HBox/NameLeft/FullName
@onready var age_date: Label = $Content/VBox/Header/HMargin/HBox/NameLeft/SubRow/AgeDate
@onready var ability: Label = $Content/VBox/Header/HMargin/HBox/NameLeft/SubRow/StRow/Ability
@onready var player_postion: Label = $Content/VBox/Middle/LeftVBox/AllgPanel/AllgVBox/AllgMargin/AllgGrid/Position
@onready var form_val: Label = $Content/VBox/Middle/LeftVBox/AllgPanel/AllgVBox/AllgMargin/AllgGrid/FormVal
@onready var kondition_val: Label = $Content/VBox/Middle/LeftVBox/AllgPanel/AllgVBox/AllgMargin/AllgGrid/KonditionVal
@onready var frische_val: Label = $Content/VBox/Middle/LeftVBox/AllgPanel/AllgVBox/AllgMargin/AllgGrid/FrischeVal
@onready var club_name: Label = $Content/VBox/Middle/RightVBox/VeinPanel/VeinVBox/VeinMargin/ClubName
@onready var talent_value: Label = $Content/VBox/Middle/RightVBox/TalentPanel/TalentVBox/TalentMargin/TalentInner/TalentValue
@onready var matches_val: Label = $Content/VBox/Middle/RightVBox/TalentPanel/TalentVBox/TalentMargin/TalentInner/MatchesVal
@onready var festgehalt_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/FestgehaltVal
@onready var auflauf_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/AuflaufVal
@onready var tor_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/TorVal
@onready var markt_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/MarktVal
@onready var vertrag_bis_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/VertragBisVal
@onready var history_entries: HBoxContainer = $Content/VBox/EntwicklungPanel/EntwicklungVBox/EntwicklungMargin/HistoryEntries


func _ready() -> void:
	player = GameState.selected_player
	_find_club_roster()
	_load_player()


func _find_club_roster() -> void:
	for club: Club in Game.all_clubs:
		if player in club.players:
			_club_players = club.players
			_player_index = _club_players.find(player)
			return


func _load_player() -> void:
	full_name.text = player.firstname + " " + player.lastname
	age_date.text = _format_age_and_date(player.birthdate)
	ability.text = player.currentAbility
	player_postion.text = player.position_label()
	form_val.text = player.currentAbility
	kondition_val.text = str(player.condition)
	frische_val.text = str(player.freshness)
	talent_value.text = player.talent
	matches_val.text = str(player.matches_played)
	club_name.text = _find_player_club()
	festgehalt_val.text = _format_money(player.salary)
	auflauf_val.text = _format_money(player.auflauf_praemie)
	tor_val.text = _format_money(player.tor_praemie)
	markt_val.text = _format_money(player.market_value)
	vertrag_bis_val.text = player.contract_end
	_populate_history()


func _populate_history() -> void:
	for child in history_entries.get_children():
		child.queue_free()
	if player.ability_history.is_empty():
		var empty_lbl := Label.new()
		empty_lbl.text = "Keine Daten"
		empty_lbl.add_theme_font_size_override("font_size", 11)
		empty_lbl.modulate = Color(0.6, 0.6, 0.6, 1.0)
		history_entries.add_child(empty_lbl)
		return
	for entry: Dictionary in player.ability_history:
		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 2)

		var lbl := Label.new()
		lbl.text = entry["label"]
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.modulate = Color(0.5, 0.5, 0.5, 1.0)
		col.add_child(lbl)

		var val := Label.new()
		val.text = str(entry["ability"])
		val.add_theme_font_size_override("font_size", 14)
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(val)

		history_entries.add_child(col)


func _on_prev_pressed() -> void:
	if _club_players.is_empty():
		return
	_player_index = (_player_index - 1 + _club_players.size()) % _club_players.size()
	player = _club_players[_player_index]
	GameState.selected_player = player
	_load_player()


func _on_next_pressed() -> void:
	if _club_players.is_empty():
		return
	_player_index = (_player_index + 1) % _club_players.size()
	player = _club_players[_player_index]
	GameState.selected_player = player
	_load_player()


func _format_age_and_date(birthdate: String) -> String:
	var parts := birthdate.split(".")
	if parts.size() < 3:
		return birthdate
	var birth_year := parts[2].to_int()
	if birth_year == 0:
		return birthdate
	var age := 1999 - birth_year
	return str(age) + " Jahre (" + birthdate + ")"


func _format_money(amount: int) -> String:
	if abs(amount) >= 1_000_000:
		return "%.2f Mio DM" % (amount / 1_000_000.0)
	return "%d DM" % amount


func _find_player_club() -> String:
	for club: Club in Game.all_clubs:
		for p: Player in club.players:
			if p == player:
				return club.name
	return ""
