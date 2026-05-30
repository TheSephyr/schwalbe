extends Control

const HOME_GAMES: int = GameConfig.FIRST_DIVISION_SIZE - 1

@onready var sponsor_value_label: Label = $Content/OuterVBox/DataPanel/DataMargin/DataVBox/Grid/SponsorValueLabel
@onready var attendance_value_label: Label = $Content/OuterVBox/DataPanel/DataMargin/DataVBox/Grid/AttendanceValueLabel
@onready var co_trainer_value_label: Label = $Content/OuterVBox/DataPanel/DataMargin/DataVBox/Grid/CoTrainerValueLabel
@onready var total_value_label: Label = $Content/OuterVBox/DataPanel/DataMargin/DataVBox/TotalHBox/TotalValueLabel


func _ready() -> void:
	_refresh()


func _refresh() -> void:
	var sponsor_income: int = Game.player_club.sponsor_income
	sponsor_value_label.text = _format_money(sponsor_income) if sponsor_income > 0 else "—"

	var attendance_revenue: int = _attendance_revenue()
	attendance_value_label.text = _format_money(attendance_revenue) if Game.player_club.planned_attendance > 0 else "—"

	var co_trainer: Trainer = Game.player_club.co_trainer
	co_trainer_value_label.text = co_trainer.full_name() if co_trainer != null else "—"

	total_value_label.text = _format_money(sponsor_income + attendance_revenue)


func _attendance_revenue() -> int:
	if Game.player_club.planned_attendance <= 0:
		return 0
	var ticket_price: int = GameConfig.TICKET_PRICE_DEFAULT
	if Game.player_club.stadium != null:
		ticket_price = Game.player_club.stadium.ticket_price
	return Game.player_club.planned_attendance * ticket_price * HOME_GAMES


func _on_sponsors_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/sponsor_scene.tscn")


func _on_attendance_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/attendance_revenue_scene.tscn")


func _on_co_trainer_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/co_trainer_scene.tscn")


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/preseason/preseason_scene.tscn")


func _format_money(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio. DM" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d DM" % [amount / 1000, amount % 1000]
	return "%d DM" % amount
