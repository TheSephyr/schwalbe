class_name Player

var firstname : String
var lastname : String
var birthdate : String
var talent : String
var currentAbility: String
var position : String
var played_matches: Array[Match]
var matches_played: int = 0

var salary: int = GameConfig.DEFAULT_SALARY
var auflauf_praemie: int = GameConfig.DEFAULT_APPEARANCE_BONUS
var tor_praemie: int = GameConfig.DEFAULT_GOAL_BONUS
var market_value: int = GameConfig.DEFAULT_MARKET_VALUE
var contract_end: String = GameConfig.DEFAULT_CONTRACT_END


static var POSITION_LABELS: Dictionary = {
	"1": "GK", "3": "CB", "4": "LB", "5": "RB",
	"6": "CDM", "7": "LM", "8": "RM", "9": "CM", "10": "ST",
}

func position_label() -> String:
	return POSITION_LABELS.get(position, position)

func _to_string():
	return "(" + lastname + ", " + firstname + ")"


func add_match(current_match: Match) -> void:
	played_matches.append(current_match)
	matches_played += 1
