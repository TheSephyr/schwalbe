class_name Club
extends Resource

var nation: String
var name: String
var players: Array[Player]
var currentLineUp: Array[Player]
var money: int = GameConfig.STARTING_CLUB_MONEY
var manager: Manager = null
var trainer: Trainer = null
var stadium: Stadium = null
var spielstil: int = GameConfig.SPIELSTIL_AUSGEWOGEN
var pressing: int = GameConfig.PRESSING_MITTEL

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
	for slot: String in slots:
		var pick: Player = _pick_best_for_position(pool, slot)
		if pick == null:
			pick = _pick_best_overall(pool)
		if pick:
			currentLineUp.append(pick)
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
