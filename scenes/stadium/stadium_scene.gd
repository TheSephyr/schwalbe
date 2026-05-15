extends Control

@onready var title_label: Label = $Content/TitlePanel/TitleLabel
@onready var name_label: Label = $Content/InfoPanel/InfoMargin/InfoVBox/NameLabel
@onready var city_label: Label = $Content/InfoPanel/InfoMargin/InfoVBox/CityLabel
@onready var capacity_label: Label = $Content/InfoPanel/InfoMargin/InfoVBox/CapacityLabel
@onready var price_value_label: Label = $Content/PricingPanel/PricingMargin/PricingVBox/PriceRow/PriceValueLabel
@onready var revenue_label: Label = $Content/PricingPanel/PricingMargin/PricingVBox/RevenueRow/RevenueLabel
@onready var north_label: Label = $Content/SchematicPanel/SchematicMargin/SchematicVBox/NorthPanel/NorthLabel
@onready var south_label: Label = $Content/SchematicPanel/SchematicMargin/SchematicVBox/SouthPanel/SouthLabel
@onready var west_label: Label = $Content/SchematicPanel/SchematicMargin/SchematicVBox/MiddleRow/WestPanel/WestLabel
@onready var east_label: Label = $Content/SchematicPanel/SchematicMargin/SchematicVBox/MiddleRow/EastPanel/EastLabel
@onready var pitch_label: Label = $Content/SchematicPanel/SchematicMargin/SchematicVBox/MiddleRow/PitchPanel/PitchLabel

var _stadium: Stadium


func _ready() -> void:
	var club := Game.player_club
	if club == null or club.stadium == null:
		title_label.text = "Kein Stadion"
		return

	_stadium = club.stadium
	title_label.text = _stadium.name
	name_label.text = "Stadion: " + _stadium.name
	city_label.text = "Stadt: " + _stadium.city
	capacity_label.text = "Kapazität: %s" % _fmt(_stadium.total())
	north_label.text = "Nord\n%s" % _fmt(_stadium.north)
	south_label.text = "Süd\n%s" % _fmt(_stadium.south)
	west_label.text = "West\n%s" % _fmt(_stadium.west)
	east_label.text = "Ost\n%s" % _fmt(_stadium.east)
	pitch_label.text = club.name
	_update_pricing_ui()


func _on_price_minus_pressed() -> void:
	_stadium.ticket_price = maxi(GameConfig.TICKET_PRICE_MIN, _stadium.ticket_price - GameConfig.TICKET_PRICE_STEP)
	_update_pricing_ui()


func _on_price_plus_pressed() -> void:
	_stadium.ticket_price = mini(GameConfig.TICKET_PRICE_MAX, _stadium.ticket_price + GameConfig.TICKET_PRICE_STEP)
	_update_pricing_ui()


func _update_pricing_ui() -> void:
	price_value_label.text = "%d DM" % _stadium.ticket_price
	var avg_attendance := int(_stadium.total() * 0.815)
	revenue_label.text = _fmt(avg_attendance * _stadium.ticket_price) + " DM"


func _fmt(n: int) -> String:
	if n <= 0:
		return "–"
	if n >= 1_000_000:
		return "%.2f Mio" % (n / 1_000_000.0)
	return "%d.%03d" % [n / 1000, n % 1000] if n >= 1000 else str(n)
