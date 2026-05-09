extends Control

@onready var club_name: Label = $Content/ClubName
@onready var nation_value: Label = $Content/Grid/NationValue
@onready var squad_value: Label = $Content/Grid/SquadValue
@onready var lineup_value: Label = $Content/Grid/LineupValue


func _ready() -> void:
	var club: Club = Game.player_club
	club_name.text = club.name
	nation_value.text = club.nation
	squad_value.text = str(club.players.size())
	lineup_value.text = str(club.currentLineUp.size())
