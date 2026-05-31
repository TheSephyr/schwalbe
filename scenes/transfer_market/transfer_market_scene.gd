extends Control

@onready var negotiations_list: VBoxContainer = $Content/ActivePanel/ActiveMargin/ActiveVBox/ActiveScroll/NegotiationsList
@onready var active_count_label: Label = $Content/ActivePanel/ActiveMargin/ActiveVBox/ActiveHeader/ActiveCount
@onready var results_list: VBoxContainer = $Content/ResultsPanel/ResultsMargin/ResultsVBox/ResultsList


func _ready() -> void:
	_build_negotiations()
	_build_results()


func _build_negotiations() -> void:
	for child in negotiations_list.get_children():
		child.queue_free()

	var count := Game.active_negotiations.size()
	active_count_label.text = "(%d)" % count

	if count == 0:
		var lbl := Label.new()
		lbl.text = "Keine laufenden Verhandlungen"
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.modulate = Color(0.6, 0.6, 0.6)
		negotiations_list.add_child(lbl)
		return

	for neg: Dictionary in Game.active_negotiations:
		var player: Player = neg["player"]
		var from_club: Club = neg["from_club"]
		var offers: Array = neg["offers"]
		var deadline := Date.new(int(neg["deadline_day"]), int(neg["deadline_month"]), int(neg["deadline_year"]))
		var days_left := Game.current_date.days_until(deadline)
		negotiations_list.add_child(_make_row(player, from_club, offers, days_left))


func _make_row(player: Player, from_club: Club, offers: Array, days_left: int) -> PanelContainer:
	var panel := PanelContainer.new()
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	margin.add_child(vbox)

	var top_row := HBoxContainer.new()
	var name_lbl := Label.new()
	name_lbl.text = player.firstname + " " + player.lastname
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", 13)
	var pos_lbl := Label.new()
	pos_lbl.text = player.position_label()
	pos_lbl.add_theme_font_size_override("font_size", 12)
	top_row.add_child(name_lbl)
	top_row.add_child(pos_lbl)
	vbox.add_child(top_row)

	var mid_row := HBoxContainer.new()
	var club_lbl := Label.new()
	club_lbl.text = from_club.name if from_club != null else "Vereinslos"
	club_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	club_lbl.add_theme_font_size_override("font_size", 11)
	club_lbl.modulate = Color(0.55, 0.55, 0.55)
	var deadline_lbl := Label.new()
	deadline_lbl.text = "%d Tage" % maxi(0, days_left)
	deadline_lbl.add_theme_font_size_override("font_size", 11)
	mid_row.add_child(club_lbl)
	mid_row.add_child(deadline_lbl)
	vbox.add_child(mid_row)

	var bot_row := HBoxContainer.new()
	var offers_lbl := Label.new()
	offers_lbl.text = "%d Gebote" % offers.size()
	offers_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	offers_lbl.add_theme_font_size_override("font_size", 11)
	bot_row.add_child(offers_lbl)

	var player_offer := _find_player_offer(offers)
	var best_salary := _best_salary(offers)
	var status_lbl := Label.new()
	status_lbl.add_theme_font_size_override("font_size", 11)
	if not player_offer.is_empty() and int(player_offer["salary"]) >= best_salary:
		status_lbl.text = "Ihr Gebot führt!"
		status_lbl.modulate = Color(0.15, 0.65, 0.15)
	elif not player_offer.is_empty():
		status_lbl.text = "Überboten!"
		status_lbl.modulate = Color(0.75, 0.15, 0.15)
	else:
		status_lbl.text = "Kein Gebot"
		status_lbl.modulate = Color(0.5, 0.5, 0.5)
	bot_row.add_child(status_lbl)
	vbox.add_child(bot_row)

	return panel


func _find_player_offer(offers: Array) -> Dictionary:
	for offer: Dictionary in offers:
		if offer["to_club"] == Game.player_club:
			return offer
	return {}


func _best_salary(offers: Array) -> int:
	var best := 0
	for offer: Dictionary in offers:
		best = maxi(best, int(offer["salary"]))
	return best


func _build_results() -> void:
	for child in results_list.get_children():
		child.queue_free()

	if GameState.transfer_results.is_empty():
		var lbl := Label.new()
		lbl.text = "Keine abgeschlossenen Transfers"
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.modulate = Color(0.6, 0.6, 0.6)
		results_list.add_child(lbl)
		return

	for result: Dictionary in GameState.transfer_results:
		var row := HBoxContainer.new()
		var name_lbl := Label.new()
		name_lbl.text = result["player_name"]
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.add_theme_font_size_override("font_size", 12)
		var transfer_lbl := Label.new()
		transfer_lbl.text = "%s → %s" % [result["from_club"], result["to_club"]]
		transfer_lbl.add_theme_font_size_override("font_size", 12)
		if bool(result["won_by_player"]):
			transfer_lbl.modulate = Color(0.15, 0.65, 0.15)
		else:
			transfer_lbl.modulate = Color(0.5, 0.5, 0.5)
		row.add_child(name_lbl)
		row.add_child(transfer_lbl)
		results_list.add_child(row)
