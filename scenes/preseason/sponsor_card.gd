class_name SponsorCard
extends PanelContainer

signal accepted(index: int)
signal negotiate_requested(index: int)

@onready var name_label: Label = $Margin/VBox/NameLabel
@onready var amount_label: Label = $Margin/VBox/AmountLabel
@onready var spacer: Control = $Margin/VBox/Spacer
@onready var accepted_label: Label = $Margin/VBox/AcceptedLabel
@onready var declined_label: Label = $Margin/VBox/DeclinedLabel
@onready var buttons_vbox: VBoxContainer = $Margin/VBox/ButtonsVBox

var _index: int = 0


func setup(offer: Dictionary, index: int) -> void:
	_index = index
	name_label.text = offer["name"]
	amount_label.text = _format_money(offer["grundbetrag"])

	var style := StyleBoxFlat.new()
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	match offer["status"]:
		"accepted":
			style.bg_color = Color(0.84, 0.93, 0.82, 1)
			style.border_color = Color(0.25, 0.55, 0.25, 1)
			spacer.visible = false
			accepted_label.visible = true
			declined_label.visible = false
			buttons_vbox.visible = false
		"declined":
			style.bg_color = Color(0.93, 0.84, 0.82, 1)
			style.border_color = Color(0.55, 0.25, 0.25, 1)
			spacer.visible = false
			accepted_label.visible = false
			declined_label.visible = true
			buttons_vbox.visible = false
		_:
			style.bg_color = Color(0.91, 0.9, 0.82, 1)
			style.border_color = Color(0.5, 0.48, 0.38, 1)
			spacer.visible = true
			accepted_label.visible = false
			declined_label.visible = false
			buttons_vbox.visible = true
	add_theme_stylebox_override("panel", style)


func _on_accept_pressed() -> void:
	accepted.emit(_index)


func _on_negotiate_pressed() -> void:
	negotiate_requested.emit(_index)


func _format_money(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio. DM" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d DM" % [amount / 1000, amount % 1000]
	return "%d DM" % amount
