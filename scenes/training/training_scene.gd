extends Control

@onready var weeks_list: VBoxContainer = $Content/VBox/MainHBox/WeeksPanel/WeeksScroll/WeeksList

func _ready() -> void:
	_build_week_rows()

func _on_randomize_pressed() -> void:
	for i: int in Game.training_plan.size():
		Game.training_plan[i] = randi_range(GameConfig.TRAINING_TYPE_CONDITION, GameConfig.TRAINING_TYPE_REGEN)
	for i: int in weeks_list.get_child_count():
		weeks_list.get_child(i).update_type(Game.training_plan[i])


func _build_week_rows() -> void:
	var row_script := load("res://scenes/training/training_week_row.gd")
	var season_start := Date.new(1, 7, Game.current_season.start_year)

	var md_in_week: Dictionary = {}
	for md: Matchday in Game.current_season.matchdays:
		var wk: int = season_start.days_until(md.date) / 7
		md_in_week[wk] = md.matchdayNumber

	for i: int in Game.training_plan.size():
		var week_start: Date = season_start.add_days(i * 7)
		var row := PanelContainer.new()
		row.set_script(row_script)
		weeks_list.add_child(row)
		row.setup(i, week_start, Game.training_plan[i], md_in_week.get(i, 0))
