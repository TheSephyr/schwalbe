extends Node

var allClubs: Array[Club]
var firstDivisionClubs: Array[Club]
var currentMatchday: Matchday
var currentMatches: Array[Match]
var singleMatches: Array[SingleMatch]
var currentSeason: Season
var player_club: Club
var current_week: int = 1

func _ready() -> void: 
	EventBus.next_matchday.connect(_on_next_matchday)
	pass # Replace with function body.

func initial_load():
	allClubs = ReadNationFile.loadNationFile("res://dbfiles/LandDeutAllNeu.sav")
	for i in 18:
		firstDivisionClubs.append(allClubs[i])
	for club in firstDivisionClubs:
		club.defaultLineUp()
		print(club.currentLineUp)
	var singleMatch: Match = Match.new(allClubs[0], allClubs[1])
	var _secondMatch: Match = Match.new(allClubs[2], allClubs[3])
	print(singleMatch.awayTeam.name)

	player_club = firstDivisionClubs[0]

	var season = Season.new(firstDivisionClubs)
	currentSeason = season
	currentMatches.append_array(season.matchdays[0].matches);
	currentMatchday = season.matchdays[0]

func _on_next_matchday():
	current_week = current_week + 1
	currentMatchday = currentSeason.nextMatchday()
	EventBus.emit_update_ui()
