extends Control

@onready var status_label: Label = $Content/OuterVBox/StatusPanel/StatusMargin/StatusLabel
@onready var sponsors_hbox: HBoxContainer = $Content/OuterVBox/SponsorsHBox
@onready var negotiation_panel: PanelContainer = $NegotiationPanel
@onready var neg_title: Label = $NegotiationPanel/NegMargin/NegVBox/NegHeader/NegTitle
@onready var neg_offer_label: Label = $NegotiationPanel/NegMargin/NegVBox/OfferLabel
@onready var counter_input: LineEdit = $NegotiationPanel/NegMargin/NegVBox/CounterInput
@onready var response_label: Label = $NegotiationPanel/NegMargin/NegVBox/ResponseLabel

var _offers: Array[Dictionary] = []
var _negotiating_index: int = -1

func _ready() -> void:
	_offers = _generate_offers()
	_rebuild_cards()
	_update_status()


func _generate_offers() -> Array[Dictionary]:
	var pool := Game.sponsors.duplicate()
	pool.shuffle()
	var result: Array[Dictionary] = []
	for i: int in mini(3, pool.size()):
		var s: Sponsor = pool[i]
		result.append({
			"name": s.name,
			"current_offer": s.income_per_season,
			"max_offer": int(s.income_per_season * 1.3),
			"status": "pending",
		})
	return result


func _rebuild_cards() -> void:
	for child in sponsors_hbox.get_children():
		child.queue_free()
	for i: int in _offers.size():
		sponsors_hbox.add_child(_make_card(_offers[i], i))


func _make_card(offer: Dictionary, index: int) -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var style := StyleBoxFlat.new()
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	match offer["status"]:
		"accepted":
			style.bg_color = Color(0.84, 0.93, 0.82, 1)
			style.border_color = Color(0.25, 0.55, 0.25, 1)
		"declined":
			style.bg_color = Color(0.93, 0.84, 0.82, 1)
			style.border_color = Color(0.55, 0.25, 0.25, 1)
		_:
			style.bg_color = Color(0.91, 0.9, 0.82, 1)
			style.border_color = Color(0.5, 0.48, 0.38, 1)
	panel.add_theme_stylebox_override("panel", style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	var name_lbl := Label.new()
	name_lbl.text = offer["name"]
	name_lbl.add_theme_font_size_override("font_size", 14)
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(name_lbl)

	var amount_lbl := Label.new()
	amount_lbl.text = _format_money(offer["current_offer"])
	amount_lbl.add_theme_font_size_override("font_size", 20)
	amount_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(amount_lbl)

	var per_lbl := Label.new()
	per_lbl.text = "pro Saison"
	per_lbl.add_theme_font_size_override("font_size", 11)
	per_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	per_lbl.modulate = Color(0.5, 0.5, 0.5, 1)
	vbox.add_child(per_lbl)

	match offer["status"]:
		"accepted":
			var lbl := Label.new()
			lbl.text = "Angenommen"
			lbl.add_theme_font_size_override("font_size", 13)
			lbl.modulate = Color(0.18, 0.55, 0.18, 1)
			lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			vbox.add_child(lbl)
		"declined":
			var lbl := Label.new()
			lbl.text = "Abgelehnt"
			lbl.add_theme_font_size_override("font_size", 13)
			lbl.modulate = Color(0.65, 0.15, 0.15, 1)
			lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			vbox.add_child(lbl)
		_:
			var spacer := Control.new()
			spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
			vbox.add_child(spacer)

			var accept_btn := Button.new()
			accept_btn.text = "Annehmen"
			accept_btn.add_theme_font_size_override("font_size", 12)
			accept_btn.pressed.connect(_accept_offer.bind(index))
			vbox.add_child(accept_btn)

			var negotiate_btn := Button.new()
			negotiate_btn.text = "Verhandeln"
			negotiate_btn.add_theme_font_size_override("font_size", 12)
			negotiate_btn.pressed.connect(_open_negotiation.bind(index))
			vbox.add_child(negotiate_btn)

	return panel


func _accept_offer(index: int) -> void:
	_offers[index]["status"] = "accepted"
	Game.sponsor_name = _offers[index]["name"]
	Game.sponsor_income = _offers[index]["current_offer"]
	_rebuild_cards()
	_update_status()


func _open_negotiation(index: int) -> void:
	_negotiating_index = index
	var offer: Dictionary = _offers[index]
	neg_title.text = offer["name"]
	neg_offer_label.text = "Aktuelles Angebot: " + _format_money(offer["current_offer"])
	counter_input.text = ""
	response_label.text = ""
	negotiation_panel.visible = true


func _on_make_offer_pressed() -> void:
	if _negotiating_index < 0:
		return
	var counter: int = counter_input.text.to_int()
	if counter <= 0:
		response_label.text = "Bitte einen gültigen Betrag eingeben."
		return
	var offer: Dictionary = _offers[_negotiating_index]
	if counter <= offer["max_offer"]:
		offer["current_offer"] = counter
		offer["status"] = "accepted"
		Game.sponsor_name = offer["name"]
		Game.sponsor_income = counter
		negotiation_panel.visible = false
		_rebuild_cards()
		_update_status()
	else:
		offer["status"] = "declined"
		negotiation_panel.visible = false
		_rebuild_cards()
		_update_status()


func _on_neg_close_pressed() -> void:
	negotiation_panel.visible = false


func _on_weiter_pressed() -> void:
	if Game.sponsor_income > 0:
		Game.player_club.money += Game.sponsor_income
	get_tree().change_scene_to_file("res://scenes/club_overview.tscn")


func _update_status() -> void:
	if Game.sponsor_name.is_empty():
		status_label.text = "Kein Sponsor ausgewählt"
		status_label.modulate = Color(0.55, 0.55, 0.55, 1)
	else:
		status_label.text = "Sponsor: " + Game.sponsor_name + "  —  " + _format_money(Game.sponsor_income) + " / Saison"
		status_label.modulate = Color(0.18, 0.55, 0.18, 1)


func _format_money(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio. DM" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d DM" % [amount / 1000, amount % 1000]
	return "%d DM" % amount
