class_name Club
	
var nation : String
var name : String
var players : Array[Player]
var currentLineUp: Array[Player]

func _to_string() -> String:
	return "(" + name + ")"
	
	
func printPlayer() -> String:
	var playerStrings: String = ""
	for player in players:
		playerStrings = playerStrings + player._to_string()
	return playerStrings
	
func defaultLineUp() -> void:
	for i in 10:
		currentLineUp.append(players[i])
