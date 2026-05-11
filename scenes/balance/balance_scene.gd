class_name BalanceScene
extends Control

@onready var bankguthaben_value: Label = $Content/AnlagenGrid/BankguthabenValue
@onready var vermoegen_value: Label = $Content/VermoegenRow/VermoegenValue
@onready var start_money_value: Label = $Content/EntwicklungGrid/StartMoneyValue
@onready var gewinn_value: Label = $Content/EntwicklungGrid/GewinnValue


func _ready() -> void:
	var club: Club = Game.player_club
	bankguthaben_value.text = _format_money(club.money)
	vermoegen_value.text = _format_money(club.money)
	start_money_value.text = _format_money(club.money)
	gewinn_value.text = _format_money(0)


func _format_money(amount: int) -> String:
	if abs(amount) >= 1_000_000:
		return "%.2f Mio DM" % (amount / 1_000_000.0)
	return "%d DM" % amount
