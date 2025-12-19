class_name Player

var firstname : String
var lastname : String
var birthdate : String
var talent : String
var currentAbility: String
var position : String
var played_matches: Array[Match]


func _to_string():
	return "(" + lastname + ", " + firstname + ")"


func add_match(current_match: Match) -> void:
	played_matches.append(current_match)
