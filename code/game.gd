extends Node

var all_clubs: Array[Club]
var first_division_clubs: Array[Club]
var current_season: Season
var player_club: Club
var current_week: int = 1

func _ready() -> void:
	EventBus.next_matchday.connect(_on_next_matchday)
	EventBus.next.connect(_on_next)


func initial_load():
	all_clubs = ReadNationFile.loadNationFile("res://dbfiles/LandDeutAllNeu.sav")
	for i in 18:
		first_division_clubs.append(all_clubs[i])
	for club in first_division_clubs:
		club.defaultLineUp()
		print(club.currentLineUp)

	player_club = first_division_clubs[0]

	var season = Season.new(first_division_clubs)
	current_season = season

func _on_next_matchday():
	current_week = current_week + 1
	EventBus.emit_update_ui()

func _on_next():
	current_week = current_week + 1
	
	EventBus.emit_update_ui()
