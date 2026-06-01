extends Control

var _thread: Thread
var _dot_count: int = 0

@onready var status_label: Label = $CenterContainer/ContentVBox/Panel/Margin/VBox/StatusLabel
@onready var file_label: Label = $CenterContainer/ContentVBox/Panel/Margin/VBox/FileLabel
@onready var dot_timer: Timer = $DotTimer


func _ready() -> void:
	var names := GameState.selected_nation_files.map(func(p: String) -> String: return p.get_file())
	file_label.text = ", ".join(names)
	dot_timer.start()
	_thread = Thread.new()
	_thread.start(_do_load)


func _do_load() -> void:
	Game.initial_load(GameState.selected_nation_files)


func _process(_delta: float) -> void:
	if _thread != null and not _thread.is_alive():
		_thread.wait_to_finish()
		_thread = null
		if Game.leagues.size() > 1:
			get_tree().change_scene_to_file("res://scenes/league_selection/league_selection_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/manager_setup/manager_setup_scene.tscn")


func _on_dot_timer_timeout() -> void:
	_dot_count = (_dot_count + 1) % 4
	status_label.text = "Lade Daten" + ".".repeat(_dot_count)
