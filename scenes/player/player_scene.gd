extends Control

var player: Player

@onready var lastname: Label = $GridContainer/Lastname
@onready var birthdate: Label = $GridContainer/Birthdate
@onready var talent: Label = $GridContainer/Talent
@onready var current_ability: Label = $GridContainer/CurrentAbility
@onready var player_position: Label = $GridContainer/Position
@onready var played_matches: Label = $GridContainer/PlayedMatches


func _ready() -> void:
	player = GameState.selected_player
	lastname.text = player.lastname
	birthdate.text = player.birthdate
	talent.text = player.talent
	current_ability.text = player.currentAbility
	player_position.text = player.position
	played_matches.text = str(player.played_matches.size())
