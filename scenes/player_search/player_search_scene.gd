extends Control

const POSITIONS: Array[String] = ["Alle", "GK", "CB", "LB", "RB", "CDM", "LM", "RM", "CM", "ST"]

@onready var position_option: OptionButton = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/PositionOption
@onready var age_min: SpinBox = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/AgeHBox/AgeMin
@onready var age_max: SpinBox = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/AgeHBox/AgeMax
@onready var talent_min: SpinBox = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/TalentHBox/TalentMin
@onready var talent_max: SpinBox = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/TalentHBox/TalentMax
@onready var ability_min: SpinBox = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/AbilityHBox/AbilityMin
@onready var ability_max: SpinBox = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/AbilityHBox/AbilityMax
@onready var free_agents_check: CheckBox = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/FreeAgentsCheck
@onready var expiring_check: CheckBox = $Content/MainHBox/LeftPanel/FilterPanel/FilterMargin/FilterVBox/ExpiringCheck
@onready var result_list: VBoxContainer = $Content/MainHBox/RightPanel/ResultScroll/ResultList
@onready var count_label: Label = $Content/MainHBox/RightPanel/CountLabel


func _ready() -> void:
	for pos: String in POSITIONS:
		position_option.add_item(pos)


func _on_search_pressed() -> void:
	for child in result_list.get_children():
		child.queue_free()

	var pos_filter := position_option.get_item_text(position_option.selected)
	if pos_filter == "Alle":
		pos_filter = ""

	var row_script := load("res://scenes/player_search/player_search_row.gd")
	var count := 0

	if not free_agents_check.button_pressed:
		for club: Club in Game.all_clubs:
			for player: Player in club.players:
				if not _matches(player, pos_filter, false):
					continue
				var row := PanelContainer.new()
				row.set_script(row_script)
				result_list.add_child(row)
				row.setup(player, club.name)
				count += 1

	for player: Player in Game.free_agents:
		if not _matches(player, pos_filter, true):
			continue
		var row := PanelContainer.new()
		row.set_script(row_script)
		result_list.add_child(row)
		row.setup(player, "Vereinslos")
		count += 1

	count_label.text = "%d Spieler gefunden" % count


func _matches(player: Player, pos_filter: String, is_free_agent: bool) -> bool:
	if pos_filter != "" and player.position_label() != pos_filter:
		return false
	var age := _calc_age(player.birthdate)
	if age < int(age_min.value) or age > int(age_max.value):
		return false
	if player.talent.to_int() < int(talent_min.value) or player.talent.to_int() > int(talent_max.value):
		return false
	if player.currentAbility.to_int() < int(ability_min.value) or player.currentAbility.to_int() > int(ability_max.value):
		return false
	if expiring_check.button_pressed and not is_free_agent:
		var parts := player.contract_end.split(".")
		var end_year := int(parts[2]) if parts.size() >= 3 else 0
		if end_year > Game.current_season.start_year + 1:
			return false
	return true


func _calc_age(birthdate: String) -> int:
	var parts := birthdate.split(".")
	if parts.size() < 3:
		return 0
	return Game.current_date.year - parts[2].to_int()
