class_name Club
extends Resource

var nation: String
var name: String
var abbreviation: String = ""
var chant: String = ""
var fan_name: String = ""
var players: Array[Player]
var currentLineUp: Array[Player]
var currentLineUpSlots: Array[String] = []
var money: int = GameConfig.STARTING_CLUB_MONEY
var manager: Manager = null
var trainer: Trainer = null
var stadium: Stadium = null
var spielstil: int = GameConfig.SPIELSTIL_AUSGEWOGEN
var pressing: int = GameConfig.PRESSING_MITTEL
var sponsor_name: String = ""
var sponsor_income: int = 0
var sponsor_duration: int = 0
var sponsor_championship_bonus: int = 0
var planned_attendance: int = 0

var home_kit_color1: KitColorTypes.KitColor = KitColorTypes.KitColor.WHITE
var home_kit_pattern: KitPatternTypes.KitPattern = KitPatternTypes.KitPattern.PLAIN
var home_kit_color2: KitColorTypes.KitColor = KitColorTypes.KitColor.WHITE
var home_kit_shorts_color: KitColorTypes.KitColor = KitColorTypes.KitColor.WHITE
var home_kit_socks_color: KitColorTypes.KitColor = KitColorTypes.KitColor.WHITE
var home_kit_socks_striped: bool = false
var away_kit_color1: KitColorTypes.KitColor = KitColorTypes.KitColor.WHITE
var away_kit_pattern: KitPatternTypes.KitPattern = KitPatternTypes.KitPattern.PLAIN
var away_kit_color2: KitColorTypes.KitColor = KitColorTypes.KitColor.WHITE
var away_kit_shorts_color: KitColorTypes.KitColor = KitColorTypes.KitColor.WHITE
var away_kit_socks_color: KitColorTypes.KitColor = KitColorTypes.KitColor.WHITE
var away_kit_socks_striped: bool = false

var abbreviation_article: AbbreviationArticleTypes.Article = AbbreviationArticleTypes.Article.NONE
var fan_attendance: FanAttendanceTypes.FanAttendance = FanAttendanceTypes.FanAttendance.AVERAGE
var fan_type: FanTypeTypes.FanType = FanTypeTypes.FanType.NORMAL
var fan_friendship_with: int = 0
var arch_rival: int = 0
var board: BoardTypes.Board = BoardTypes.Board.NORMAL
var cup_team: int = 0
var opposition: OppositionTypes.Opposition = OppositionTypes.Opposition.NON_EXISTENT
var amateur_section_of: int = 0
var pro_section_of: int = 0
var financial_strength: FinancialStrengthTypes.FinancialStrength = FinancialStrengthTypes.FinancialStrength.MINIMAL
var max_fan_attendance: int = 0
var hooligans: HooliganTypes.Hooligans = HooliganTypes.Hooligans.NONE
var media_city: String = ""
var all_time_goals: int = 0
var all_time_goals_against: int = 0
var all_time_matches: int = 0
var all_time_points: int = 0
var chairman_lastname: String = ""
var chairman_firstname: String = ""
var chairman_birthday: String = ""
var public_company: bool = false
var titles_championships: int = 0
var titles_cups: int = 0
var titles_league_cups: int = 0
var titles_europa_leagues: int = 0
var titles_champions_leagues: int = 0
var titles_world_cups: int = 0
var regional_league: RegionalLeagueTypes.RegionalLeague = RegionalLeagueTypes.RegionalLeague.NORTH
var founding_year: int = 0

func total_daily_wages() -> int:
	var yearly_total: int = 0
	for player: Player in players:
		yearly_total += player.salary
	return yearly_total / 365


func pay_wages(days: int) -> void:
	money -= total_daily_wages() * days


func _to_string() -> String:
	return "(" + name + ")"


func printPlayer() -> String:
	var playerStrings: String = ""
	for player in players:
		playerStrings = playerStrings + player._to_string()
	return playerStrings

const FORMATIONS: Dictionary = {
	"4-4-2": ["GK", "CB", "CB", "LB", "RB", "LM", "CM", "CM", "RM", "ST", "ST"],
	"5-3-2": ["GK", "CB", "CB", "CB", "LB", "RB", "CDM", "CM", "RM", "ST", "ST"],
	"4-3-3": ["GK", "CB", "CB", "LB", "RB", "CDM", "CM", "CM", "LM", "ST", "RM"],
}

func defaultLineUp() -> void:
	apply_formation("4-4-2")

func apply_formation(formation_name: String) -> void:
	var slots: Array = FORMATIONS.get(formation_name, [])
	if slots.is_empty():
		return
	var pool: Array[Player] = players.duplicate()
	currentLineUp.clear()
	currentLineUpSlots.clear()
	for slot: String in slots:
		var pick: Player = _pick_best_for_position(pool, slot)
		if pick == null:
			pick = _pick_best_overall(pool)
		if pick:
			currentLineUp.append(pick)
			currentLineUpSlots.append(slot)
			pool.erase(pick)

func _pick_best_for_position(pool: Array[Player], pos_label: String) -> Player:
	var best: Player = null
	var best_ability: int = -1
	for player: Player in pool:
		if player.position_label() == pos_label:
			var ability: int = player.currentAbility.to_int()
			if ability > best_ability:
				best_ability = ability
				best = player
	return best

func _pick_best_overall(pool: Array[Player]) -> Player:
	var best: Player = null
	var best_ability: int = -1
	for player: Player in pool:
		var ability: int = player.currentAbility.to_int()
		if ability > best_ability:
			best_ability = ability
			best = player
	return best
