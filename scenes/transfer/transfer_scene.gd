extends Control

@onready var info_content: VBoxContainer = $Content/InfoPanel/InfoMargin/InfoContent
@onready var offer_label: Label = $Content/OfferPanel/OfferMargin/OfferVBox/OfferRow/OfferLabel
@onready var status_label: Label = $Content/StatusLabel
@onready var offer_button: Button = $Content/ButtonRow/OfferButton

var _player: Player
var _source_club: Club
var _offer: int

const OFFER_STEP := 50_000


func _ready() -> void:
	_player = GameState.selected_player
	_source_club = GameState.transfer_source_club
	if _player == null:
		return
	_offer = _player.market_value
	_build_info()
	_update_offer_label()


func _build_info() -> void:
	_add_row(info_content, "Spieler", _player.lastname + ", " + _player.firstname)
	_add_row(info_content, "Position", _player.position_label())
	_add_row(info_content, "Verein", _source_club.name if _source_club != null else "–")
	_add_row(info_content, "Marktwert", _fmt(_player.market_value))
	_add_row(info_content, "Vertragsende", _player.contract_end)


func _add_row(parent: VBoxContainer, label_text: String, value_text: String) -> void:
	var row := HBoxContainer.new()
	var lbl := Label.new()
	lbl.text = label_text
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 12)
	var val := Label.new()
	val.text = value_text
	val.add_theme_font_size_override("font_size", 12)
	row.add_child(lbl)
	row.add_child(val)
	parent.add_child(row)


func _update_offer_label() -> void:
	offer_label.text = _fmt(_offer)


func _on_minus_pressed() -> void:
	_offer = maxi(0, _offer - OFFER_STEP)
	_update_offer_label()


func _on_plus_pressed() -> void:
	_offer += OFFER_STEP
	_update_offer_label()


func _on_offer_pressed() -> void:
	var threshold := int(_player.market_value * randf_range(0.8, 1.1))
	if _offer >= threshold:
		status_label.text = "Angebot angenommen! Ablöse: %s" % _fmt(_offer)
		offer_button.disabled = true
		GameState.transfer_context = GameState.TransferContext.NEGOTIATION
		GameState.transfer_fee = _offer
		get_tree().change_scene_to_file("res://scenes/contract/contract_scene.tscn")
	else:
		status_label.text = "Angebot abgelehnt. Höheres Angebot nötig."


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/player_search/player_search_scene.tscn")


func _fmt(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio DM" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d DM" % [amount / 1000, amount % 1000]
	return "%d DM" % amount
