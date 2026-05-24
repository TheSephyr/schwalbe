class_name Player

var firstname : String
var lastname : String
var birthdate : String
var talent : String
var currentAbility: String
var position : String
var played_matches: Array[Match]
var matches_played: int = 0

var ability_history: Array[Dictionary] = []
var negotiating: bool = false

var condition: int = randi_range(GameConfig.DEFAULT_CONDITION_MIN, GameConfig.DEFAULT_CONDITION_MAX)
var freshness: int = randi_range(GameConfig.DEFAULT_FRESHNESS_MIN, GameConfig.DEFAULT_FRESHNESS_MAX)

var salary: int = GameConfig.DEFAULT_SALARY
var auflauf_praemie: int = GameConfig.DEFAULT_APPEARANCE_BONUS
var tor_praemie: int = GameConfig.DEFAULT_GOAL_BONUS
var market_value: int = GameConfig.DEFAULT_MARKET_VALUE
var contract_end: String = GameConfig.DEFAULT_CONTRACT_END


static var POSITION_LABELS: Dictionary = {
	"1": "GK", "2": "LI", "3": "CB", "4": "LB", "5": "RB",
	"6": "CDM", "7": "LM", "8": "RM", "9": "CM", "10": "ST",
}

func position_label() -> String:
	return POSITION_LABELS.get(position, position)

func _to_string():
	return "(" + lastname + ", " + firstname + ")"


func generate_contract() -> void:
	var ability_val := currentAbility.to_int()
	var talent_val := talent.to_int()
	var combined := ability_val * GameConfig.CONTRACT_ABILITY_WEIGHT + talent_val * GameConfig.CONTRACT_TALENT_WEIGHT
	var curve := pow(combined / 100.0, GameConfig.CONTRACT_CURVE_POWER)
	salary = (_scaled_rand(GameConfig.CONTRACT_MIN_SALARY, GameConfig.CONTRACT_MAX_SALARY, curve) / 1000) * 1000
	auflauf_praemie = (_scaled_rand(GameConfig.CONTRACT_MIN_APPEARANCE_BONUS, GameConfig.CONTRACT_MAX_APPEARANCE_BONUS, curve) / 100) * 100
	market_value = (_scaled_rand(GameConfig.CONTRACT_MIN_MARKET_VALUE, GameConfig.CONTRACT_MAX_MARKET_VALUE, curve) / 1000) * 1000
	contract_end = "30.06.%d" % (GameConfig.SEASON_START_YEAR + randi_range(1, 4))


func _scaled_rand(min_val: int, max_val: int, curve: float) -> int:
	var base := min_val + (max_val - min_val) * curve
	var factor := randf_range(1.0 - GameConfig.CONTRACT_RAND_SPREAD, 1.0 + GameConfig.CONTRACT_RAND_SPREAD)
	return int(base * factor)


func add_match(current_match: Match) -> void:
	played_matches.append(current_match)
	matches_played += 1
	condition = maxi(GameConfig.MIN_CONDITION, condition - GameConfig.MATCH_CONDITION_LOSS)
	freshness = maxi(GameConfig.MIN_FRESHNESS, freshness - GameConfig.MATCH_FRESHNESS_LOSS)
