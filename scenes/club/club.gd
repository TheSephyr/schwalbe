extends Control

@onready var player_list: VBoxContainer = $Content/ScrollContainer/PlayerList
@onready var current_button: Button = $Content/ViewToggle/CurrentButton
@onready var next_season_button: Button = $Content/ViewToggle/NextSeasonButton

var _scene: PackedScene = preload("res://scenes/single_player_in_club.tscn")


func _ready() -> void:
	_populate(false)


func _on_current_pressed() -> void:
	current_button.disabled = true
	next_season_button.disabled = false
	_populate(false)


func _on_next_season_pressed() -> void:
	current_button.disabled = false
	next_season_button.disabled = true
	_populate(true)


func _populate(next_season: bool) -> void:
	for child in player_list.get_children():
		child.queue_free()

	var players: Array[Player] = []
	if next_season:
		players = _next_season_squad()
	else:
		players = Game.player_club.players

	for player: Player in players:
		var entry: SinglePlayerInClub = _scene.instantiate()
		player_list.add_child(entry)
		entry.init(player)


func _next_season_squad() -> Array[Player]:
	var next_year: int = Game.current_season.start_year + 1
	var squad: Array[Player] = []

	for player: Player in Game.player_club.players:
		var parts := player.contract_end.split(".")
		var end_year := int(parts[2]) if parts.size() >= 3 else 0
		if end_year > next_year:
			squad.append(player)

	for t: Dictionary in Game.pending_transfers:
		squad.append(t["player"])

	return squad
