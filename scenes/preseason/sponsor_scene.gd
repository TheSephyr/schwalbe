extends Control

@onready var status_label: Label = $Content/OuterVBox/StatusPanel/StatusMargin/StatusLabel
@onready var sponsors_hbox: HBoxContainer = $Content/OuterVBox/SponsorsHBox
@onready var negotiation_dialog: NegotiationDialog = $NegotiationDialog

const SPONSOR_CARD_SCENE := preload("res://scenes/preseason/sponsor_card.tscn")

var _offers: Array[Dictionary] = []
var _negotiating_index: int = -1


func _ready() -> void:
	_offers = _generate_offers()
	_rebuild_cards()
	_update_status()
	negotiation_dialog.offer_submitted.connect(_on_offer_submitted)


func _generate_offers() -> Array[Dictionary]:
	var pool := Game.sponsors.duplicate()
	pool.shuffle()
	var result: Array[Dictionary] = []
	for i: int in mini(3, pool.size()):
		var s: Sponsor = pool[i]
		var base := s.income_per_season
		var laufzeit := randi_range(1, 3)
		var meister := (int(base * randf_range(0.5, 1.5)) / 50000) * 50000
		result.append({
			"name": s.name,
			"status": "pending",
			"grundbetrag": base,
			"max_grundbetrag": int(base * 1.3),
			"laufzeit": laufzeit,
			"max_laufzeit": laufzeit + 1,
			"meister_aufstieg": meister,
			"max_meister_aufstieg": int(meister * 1.5),
		})
	return result


func _rebuild_cards() -> void:
	for child in sponsors_hbox.get_children():
		child.queue_free()
	for i: int in _offers.size():
		var card := SPONSOR_CARD_SCENE.instantiate() as SponsorCard
		sponsors_hbox.add_child(card)
		card.setup(_offers[i], i)
		card.accepted.connect(_on_card_accepted)
		card.negotiate_requested.connect(_on_card_negotiate)


func _on_card_accepted(index: int) -> void:
	_offers[index]["status"] = "accepted"
	var offer := _offers[index]
	Game.player_club.sponsor_name = offer["name"]
	Game.player_club.sponsor_income = offer["grundbetrag"]
	Game.player_club.sponsor_duration = offer["laufzeit"]
	Game.player_club.sponsor_championship_bonus = offer["meister_aufstieg"]
	_rebuild_cards()
	_update_status()


func _on_card_negotiate(index: int) -> void:
	_negotiating_index = index
	var offer := _offers[index]
	var current := {}
	if not Game.player_club.sponsor_name.is_empty():
		current = {
			"grundbetrag": Game.player_club.sponsor_income,
			"laufzeit": Game.player_club.sponsor_duration,
			"meister_aufstieg": Game.player_club.sponsor_championship_bonus,
		}
	negotiation_dialog.open(offer["name"], current, offer)


func _on_offer_submitted(demands: Dictionary) -> void:
	if _negotiating_index < 0:
		return
	var offer := _offers[_negotiating_index]
	var accepted: bool = (
		demands["grundbetrag"] <= offer["max_grundbetrag"] and
		demands["laufzeit"] <= offer["max_laufzeit"] and
		demands["meister_aufstieg"] <= offer["max_meister_aufstieg"]
	)
	if accepted:
		offer["status"] = "accepted"
		offer["grundbetrag"] = demands["grundbetrag"]
		Game.player_club.sponsor_name = offer["name"]
		Game.player_club.sponsor_income = demands["grundbetrag"]
		Game.player_club.sponsor_duration = demands["laufzeit"]
		Game.player_club.sponsor_championship_bonus = demands["meister_aufstieg"]
	else:
		offer["status"] = "declined"
	negotiation_dialog.visible = false
	_rebuild_cards()
	_update_status()


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/kalkulation_scene.tscn")


func _update_status() -> void:
	if Game.player_club.sponsor_name.is_empty():
		status_label.text = "Kein Sponsor ausgewählt"
		status_label.modulate = Color(0.55, 0.55, 0.55, 1)
	else:
		status_label.text = (
			"Sponsor: %s  —  %s / Saison  |  %d J.  |  Bonus: %s" % [
				Game.player_club.sponsor_name,
				_format_money(Game.player_club.sponsor_income),
				Game.player_club.sponsor_duration,
				_format_money(Game.player_club.sponsor_championship_bonus),
			]
		)
		status_label.modulate = Color(0.18, 0.55, 0.18, 1)


func _format_money(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio. DM" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d DM" % [amount / 1000, amount % 1000]
	return "%d DM" % amount
