extends Control

@onready var club_name: Label = $Content/TitlePanel/ClubName
@onready var nation_value: Label = $Content/InfoPanel/Grid/NationValue
@onready var squad_value: Label = $Content/InfoPanel/Grid/SquadValue
@onready var lineup_value: Label = $Content/InfoPanel/Grid/LineupValue


func _ready() -> void:
	var club: Club = Game.player_club
	club_name.text = club.name
	nation_value.text = club.nation
	squad_value.text = str(club.players.size())
	lineup_value.text = str(club.currentLineUp.size())
