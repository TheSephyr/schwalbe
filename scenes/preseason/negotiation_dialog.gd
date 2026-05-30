class_name NegotiationDialog
extends PanelContainer

signal offer_submitted(demands: Dictionary)

@onready var title_label: Label = $Margin/VBox/Header/TitleLabel
@onready var current_grundbetrag: Label = $Margin/VBox/Grid/CurrentGrundbetrag
@onready var offer_grundbetrag: Label = $Margin/VBox/Grid/OfferGrundbetrag
@onready var grundbetrag_spin: SpinBox = $Margin/VBox/Grid/GrundbetragSpin
@onready var current_laufzeit: Label = $Margin/VBox/Grid/CurrentLaufzeit
@onready var offer_laufzeit: Label = $Margin/VBox/Grid/OfferLaufzeit
@onready var laufzeit_spin: SpinBox = $Margin/VBox/Grid/LaufzeitSpin
@onready var current_meister: Label = $Margin/VBox/Grid/CurrentMeister
@onready var offer_meister: Label = $Margin/VBox/Grid/OfferMeister
@onready var meister_spin: SpinBox = $Margin/VBox/Grid/MeisterSpin


func _ready() -> void:
	visible = false


func open(sponsor_name: String, current: Dictionary, offer: Dictionary) -> void:
	title_label.text = sponsor_name

	if current.is_empty():
		current_grundbetrag.text = "—"
		current_laufzeit.text = "—"
		current_meister.text = "—"
	else:
		current_grundbetrag.text = _format_money(current.get("grundbetrag", 0))
		current_laufzeit.text = "%d J." % current.get("laufzeit", 0)
		current_meister.text = _format_money(current.get("meister_aufstieg", 0))

	offer_grundbetrag.text = _format_money(offer["grundbetrag"])
	offer_laufzeit.text = "%d J." % offer["laufzeit"]
	offer_meister.text = _format_money(offer["meister_aufstieg"])

	grundbetrag_spin.value = offer["grundbetrag"]
	laufzeit_spin.value = offer["laufzeit"]
	meister_spin.value = offer["meister_aufstieg"]

	visible = true


func _on_make_offer_pressed() -> void:
	offer_submitted.emit({
		"grundbetrag": int(grundbetrag_spin.value),
		"laufzeit": int(laufzeit_spin.value),
		"meister_aufstieg": int(meister_spin.value),
	})


func _on_close_pressed() -> void:
	visible = false


func _format_money(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio." % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d" % [amount / 1000, amount % 1000]
	return "%d" % amount
