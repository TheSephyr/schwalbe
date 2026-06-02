class_name Matchday

var matchdayNumber: int = 0
var played: bool = false
var matches: Array[Match] = []
var date: Date


func _init(allMatches: Array[Match], numberOfMatchday: int, matchDate: Date) -> void:
	matches = allMatches
	matchdayNumber = numberOfMatchday
	date = matchDate
	
func simulateMatches():
	if(!played):
		for singleMatch in matches:
			singleMatch.simulateMatch()
		played = true
