class_name Season


const POINTS_FOR_WIN = 3
const POINTS_FOR_DRAW = 1
var current_matchday: int = 1
var matchdays: Array[Matchday] = []
var table: Table
var finished: bool


func _init(clubs: Array[Club]):
	var num_teams: int = clubs.size()
	var num_rounds: int = num_teams - 1

	# First half: each pair meets once
	for round in range(num_rounds):
		var matches: Array[Match] = []
		for i in range(num_teams / 2):
			var home_index = (round + i) % (num_teams - 1)
			var away_index = (num_teams - 1 - i + round) % (num_teams - 1)
			var home_team = clubs[home_index]
			var away_team = clubs[away_index]
			if i == 0:
				away_team = clubs[num_teams - 1]
			matches.append(Match.new(home_team, away_team))
		matchdays.append(Matchday.new(matches, round + 1))

	# Second half: same fixtures with home/away swapped
	for round in range(num_rounds):
		var matches: Array[Match] = []
		for m: Match in matchdays[round].matches:
			matches.append(Match.new(m.awayTeam, m.homeTeam))
		matchdays.append(Matchday.new(matches, num_rounds + round + 1))

	table = Table.new(clubs)


func update_table() -> void:
	table.initTable()
	for matchday: Matchday in matchdays:
		for singleMatch: Match in matchday.matches:
			if(singleMatch.played):
				var teamstandingHome: TeamStanding = table.findByTeam(singleMatch.homeTeam)
				var teamstandingAway: TeamStanding = table.findByTeam(singleMatch.awayTeam)
				var scoreHome: int = singleMatch.scoreHome
				var scoreAway: int = singleMatch.scoreAway
				if(scoreHome == scoreAway):
					teamstandingHome.draw(scoreHome, scoreAway)
					teamstandingAway.draw(scoreAway, scoreHome)
				if(scoreHome > scoreAway):
					teamstandingHome.win(scoreHome, scoreAway)
					teamstandingAway.loose(scoreAway, scoreHome)
				if(scoreAway > scoreHome):
					teamstandingHome.loose(scoreHome, scoreAway)
					teamstandingAway.win(scoreAway, scoreHome)
	table.update()


func next_matchday() -> Matchday:
	if(current_matchday < matchdays.size()):
		current_matchday = current_matchday + 1
	else:
		current_matchday = 1
	print_debug("Current Matchday:" + str(current_matchday))
	return matchdays[current_matchday - 1]


func previous_matchday() -> Matchday:
	if(current_matchday > 0):
		current_matchday = current_matchday - 1
	else:
		current_matchday = matchdays.size()
	print_debug("Current Matchday: " + str(current_matchday))
	return matchdays[current_matchday - 1]


func get_current_matchday() -> Matchday:
	return matchdays[current_matchday - 1]


func simulate_next_matchday() -> void:
	var matchday: Matchday = get_current_matchday()
	matchday.simulateMatches()
	if current_matchday < matchdays.size():
		current_matchday = current_matchday + 1
	else:
		finished = true


func simulate_season() -> void:
	for singleMatchday: Matchday in matchdays:
		singleMatchday.simulateMatches()
