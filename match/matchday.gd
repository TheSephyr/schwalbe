class_name Matchday

var matchdayNumber: int = 0
var played: bool = false
var matches: Array[Match] = []

func _init(allMatches: Array[Match], numberOfMatchday: int):
	matches = allMatches
	matchdayNumber = numberOfMatchday
	
func simulateMatches():
	if(!played):
		for singleMatch in matches:
			singleMatch.simulateMatch()
		played = true
		Game.current_season.updateTable()
