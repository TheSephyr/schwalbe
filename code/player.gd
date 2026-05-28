class_name Player

var firstname : String
var lastname : String
var birthdate : String
var talent : String #TODO: Change this to the enum
var currentAbility: String
var skin_color: SkinColorTypes.SkinColor
var hair_color: HairColorTypes.HairColor
var country: int #TODO: Update this to an enum

var position : String
var secondary_position_1: PositionTypes.Position
var secondary_position_2: PositionTypes.Position
var positive_skills: Array[PlayerSkillTypes.Skill]
var negative_skills: Array[PlayerSkillTypes.Skill]
var gk_positive_skills: Array[GoalkeeperSkillTypes.Skill]
var gk_negative_skills: Array[GoalkeeperSkillTypes.Skill]
var characteristics: Array[PlayerCharacteristicTypes.Characteristic]
var character: PlayerCharacterTypes.Character
var has_stage_name: bool #TODO: Is this value even needed?
var stage_name: String
var foot: FootTypes.Foot
var health: HealthTypes.Health
var crowd_appeal: CrowdAppealTypes.CrowdAppeal
var country_2: int #TODO: Update this to enum
var nation_player: int #TODO: Create a enum for this.
var captain_retirement: int
var squad_number: int
var hair_style: HairStyleTypes.HairStyle
var beard: BeardTypes.Beard

var training_skill: int = 0
var training_progress: float = 0.0

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

static var POSITION_CODES: Dictionary = {
	"GK": "1", "LI": "2", "CB": "3", "LB": "4", "RB": "5",
	"CDM": "6", "LM": "7", "RM": "8", "CM": "9", "ST": "10",
}

func position_label() -> String:
	return POSITION_LABELS.get(position, position)


func effective_strength(slot: String) -> int:
	var base: int = currentAbility.to_int()
	var str_val: int = base
	var avg_fitness: float = (condition + freshness) / 2.0
	str_val += clampi(roundi((avg_fitness - 50.0) / 25.0), -2, 2)
	str_val += _talent_bonus(base)
	if base > 75:
		str_val = mini(str_val, 80)
	str_val += positive_skills.size() * 10
	str_val -= negative_skills.size() * 10
	str_val -= _position_penalty(slot)
	return maxi(1, str_val)


func _talent_bonus(base_ability: int) -> int:
	var talent_val: int = talent.to_int()
	if talent_val == 0:
		return 0
	var full_bonus: int = (3 - talent_val) * 10
	if base_ability > 75:
		return full_bonus / 2
	return full_bonus


func _position_penalty(slot: String) -> int:
	if slot.is_empty() or position_label() == slot:
		return 0
	var sec1_label: String = POSITION_LABELS.get(str(int(secondary_position_1)), "")
	var sec2_label: String = POSITION_LABELS.get(str(int(secondary_position_2)), "")
	if sec1_label == slot or sec2_label == slot:
		return 0
	var slot_code: String = POSITION_CODES.get(slot, "")
	if slot_code.is_empty():
		return 0
	return _position_distance(position.to_int(), slot_code.to_int()) / 2


static func _position_distance(a: int, b: int) -> int:
	if a == b:
		return 0
	if a == 1 or b == 1:
		return 8
	var ga: int = 1 if a <= 5 else (2 if a <= 9 else 3)
	var gb: int = 1 if b <= 5 else (2 if b <= 9 else 3)
	if ga == gb:
		return absi(a - b)
	return absi(ga - gb) * 2 + 1

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
