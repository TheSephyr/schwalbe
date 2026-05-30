extends Control

const HOME_GAMES: int = GameConfig.FIRST_DIVISION_SIZE - 1

@onready var capacity_label: Label = $Content/OuterVBox/InfoPanel/InfoMargin/InfoVBox/CapacityLabel
@onready var attendance_slider: HSlider = $Content/OuterVBox/SliderPanel/SliderMargin/SliderVBox/AttendanceSlider
@onready var attendance_value_label: Label = $Content/OuterVBox/SliderPanel/SliderMargin/SliderVBox/AttendanceValueLabel
@onready var revenue_label: Label = $Content/OuterVBox/SliderPanel/SliderMargin/SliderVBox/RevenueLabel


func _ready() -> void:
	var stadium: Stadium = Game.player_club.stadium
	var capacity: int = stadium.total() if stadium != null else 1
	capacity_label.text = "Stadionkapazität: %s Zuschauer" % _format_int(capacity)

	attendance_slider.min_value = 1
	attendance_slider.max_value = capacity
	attendance_slider.step = 100

	var default_attendance: int = Game.player_club.planned_attendance
	if default_attendance <= 0:
		var max_fans: int = Game.player_club.max_fan_attendance
		default_attendance = clampi(max_fans if max_fans > 0 else capacity / 2, 1, capacity)
	attendance_slider.value = default_attendance

	_update_labels(int(attendance_slider.value))
	attendance_slider.value_changed.connect(_on_slider_value_changed)


func _on_slider_value_changed(value: float) -> void:
	var attendance: int = int(value)
	Game.player_club.planned_attendance = attendance
	_update_labels(attendance)


func _update_labels(attendance: int) -> void:
	attendance_value_label.text = "%s Zuschauer" % _format_int(attendance)
	var ticket_price: int = Game.player_club.stadium.ticket_price if Game.player_club.stadium != null else GameConfig.TICKET_PRICE_DEFAULT
	var season_revenue: int = attendance * ticket_price * HOME_GAMES
	revenue_label.text = "Erwartete Einnahmen: %s / Saison  (%d Heimspiele × %s / Spiel)" % [
		_format_money(season_revenue),
		HOME_GAMES,
		_format_money(attendance * ticket_price),
	]


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/calculation_scene.tscn")


func _format_int(value: int) -> String:
	if value >= 1000:
		return "%d.%03d" % [value / 1000, value % 1000]
	return "%d" % value


func _format_money(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio. DM" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d DM" % [amount / 1000, amount % 1000]
	return "%d DM" % amount
