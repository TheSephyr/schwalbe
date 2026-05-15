class_name Match

var homeTeam: Club
var awayTeam: Club
var scoreHome: int = 0
var scoreAway: int = 0
var played: bool = false



func _init(homeTeamThis: Club, awayTeamThis: Club) -> void:
	homeTeam = homeTeamThis
	awayTeam = awayTeamThis


func simulateMatch() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var home_str := _lineup_strength(homeTeam) * GameConfig.HOME_ADVANTAGE
	var away_str := _lineup_strength(awayTeam)
	var total := home_str + away_str

	var home_lambda := GameConfig.MATCH_BASE_LAMBDA + GameConfig.MATCH_SCALE * (home_str / total)
	var away_lambda := GameConfig.MATCH_BASE_LAMBDA + GameConfig.MATCH_SCALE * (away_str / total)

	scoreHome = _poisson(home_lambda, rng)
	scoreAway = _poisson(away_lambda, rng)

	add_match_to_player(homeTeam)
	add_match_to_player(awayTeam)
	played = true


func _lineup_strength(club: Club) -> float:
	if club.currentLineUp.is_empty():
		return 1.0
	var total := 0
	for player: Player in club.currentLineUp:
		total += player.currentAbility.to_int()
	return float(total) / club.currentLineUp.size()


# Knuth's algorithm: returns a Poisson-distributed integer with the given mean.
func _poisson(lambda: float, rng: RandomNumberGenerator) -> int:
	var threshold := exp(-lambda)
	var k := 0
	var p := 1.0
	while true:
		k += 1
		p *= rng.randf()
		if p <= threshold:
			break
	return k - 1


func add_match_to_player(team: Club) -> void:
	for player: Player in team.currentLineUp:
		player.add_match(self)
		team.money -= player.auflauf_praemie
