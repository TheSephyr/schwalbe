extends Control

@onready var player_list: VBoxContainer = $Content/ScrollContainer/PlayerList


func _ready() -> void:
	for player: Player in Game.player_club.players:
		var entry: SinglePlayerInClub = preload("res://scenes/single_player_in_club.tscn").instantiate()
		player_list.add_child(entry)
		entry.init(player)
