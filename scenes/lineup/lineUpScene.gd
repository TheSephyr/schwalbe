extends Control

var _lineup: Array[Player] = []
var _bench: Array[Player] = []
var _selected_lineup_idx: int = -1
var _selected_lineup_btn: Button = null

@onready var lineup_list: VBoxContainer = $Content/ListsRow/LineupPanel/Scroll/LineupList
@onready var bench_list: VBoxContainer = $Content/ListsRow/BenchPanel/Scroll/BenchList


func _ready() -> void:
	_load_from_club()


func _load_from_club() -> void:
	_lineup = Game.player_club.currentLineUp.duplicate()
	_bench.clear()
	for player: Player in Game.player_club.players:
		if player not in _lineup:
			_bench.append(player)
	_rebuild_lists()


func _rebuild_lists() -> void:
	for child in lineup_list.get_children():
		child.queue_free()
	for child in bench_list.get_children():
		child.queue_free()
	_selected_lineup_idx = -1
	_selected_lineup_btn = null

	for i: int in _lineup.size():
		lineup_list.add_child(_make_lineup_button(_lineup[i], i))
	for i: int in _bench.size():
		bench_list.add_child(_make_bench_button(_bench[i], i))


func _make_lineup_button(player: Player, idx: int) -> Button:
	var btn := Button.new()
	btn.text = player.position_label() + "  " + player.lastname + ", " + player.firstname + "  (" + player.currentAbility + ")"
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.pressed.connect(_on_lineup_pressed.bind(idx, btn))
	return btn


func _make_bench_button(player: Player, idx: int) -> Button:
	var btn := Button.new()
	btn.text = player.position_label() + "  " + player.lastname + ", " + player.firstname + "  (" + player.currentAbility + ")"
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.pressed.connect(_on_bench_pressed.bind(idx))
	return btn


func _on_lineup_pressed(idx: int, btn: Button) -> void:
	if _selected_lineup_btn:
		_selected_lineup_btn.modulate = Color.WHITE
	if _selected_lineup_idx == idx:
		_selected_lineup_idx = -1
		_selected_lineup_btn = null
		return
	_selected_lineup_idx = idx
	_selected_lineup_btn = btn
	btn.modulate = Color(0.6, 1.0, 0.6)


func _on_bench_pressed(idx: int) -> void:
	if _selected_lineup_idx < 0:
		return
	var tmp: Player = _lineup[_selected_lineup_idx]
	_lineup[_selected_lineup_idx] = _bench[idx]
	_bench[idx] = tmp
	Game.player_club.currentLineUp = _lineup.duplicate()
	_rebuild_lists()


func _on_formation_pressed(formation: String) -> void:
	Game.player_club.apply_formation(formation)
	_load_from_club()
