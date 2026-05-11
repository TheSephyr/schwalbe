extends Control

var player: Player

@onready var full_name: Label = $Content/VBox/Header/HMargin/HBox/NameLeft/FullName
@onready var age_date: Label = $Content/VBox/Header/HMargin/HBox/NameLeft/SubRow/AgeDate
@onready var ability: Label = $Content/VBox/Header/HMargin/HBox/NameLeft/SubRow/StRow/Ability
@onready var player_postion: Label = $Content/VBox/Middle/LeftVBox/AllgPanel/AllgVBox/AllgMargin/AllgGrid/Position
@onready var form_val: Label = $Content/VBox/Middle/LeftVBox/AllgPanel/AllgVBox/AllgMargin/AllgGrid/FormVal
@onready var club_name: Label = $Content/VBox/Middle/RightVBox/VeinPanel/VeinVBox/VeinMargin/ClubName
@onready var talent_value: Label = $Content/VBox/Middle/RightVBox/TalentPanel/TalentVBox/TalentMargin/TalentInner/TalentValue
@onready var matches_val: Label = $Content/VBox/Middle/RightVBox/TalentPanel/TalentVBox/TalentMargin/TalentInner/MatchesVal
@onready var festgehalt_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/FestgehaltVal
@onready var auflauf_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/AuflaufVal
@onready var tor_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/TorVal
@onready var markt_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/MarktVal
@onready var vertrag_bis_val: Label = $Content/VBox/Middle/RightVBox/VertragPanel/VertragVBox/VertragMargin/VertragGrid/VertragBisVal


func _ready() -> void:
	player = GameState.selected_player
	full_name.text = player.firstname + " " + player.lastname
	age_date.text = _format_age_and_date(player.birthdate)
	ability.text = player.currentAbility
	player_postion.text = player.position_label()
	form_val.text = player.currentAbility
	talent_value.text = player.talent
	matches_val.text = str(player.matches_played)
	club_name.text = _find_player_club()
	festgehalt_val.text = _format_money(player.salary)
	auflauf_val.text = _format_money(player.auflauf_praemie)
	tor_val.text = _format_money(player.tor_praemie)
	markt_val.text = _format_money(player.market_value)
	vertrag_bis_val.text = player.contract_end


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
