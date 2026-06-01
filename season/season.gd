class_name Season


var league: League
var current_matchday: int = 1
var matchdays: Array[Matchday] = []
var table: Table
var finished: bool
var start_year: int = GameConfig.SEASON_START_YEAR


func _init(p_league: League, year: int = GameConfig.SEASON_START_YEAR) -> void:
	league = p_league
	start_year = year
	var clubs: Array[Club] = league.clubs
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
		var md_num: int = round + 1
		matchdays.append(Matchday.new(matches, md_num, _matchday_date(md_num, year)))

	# Second half: same fixtures with home/away swapped
	for round in range(num_rounds):
		var matches: Array[Match] = []
		for m: Match in matchdays[round].matches:
			matches.append(Match.new(m.awayTeam, m.homeTeam))
		var md_num: int = num_rounds + round + 1
		matchdays.append(Matchday.new(matches, md_num, _matchday_date(md_num, year)))

	table = Table.new(clubs)


# Bundesliga-style schedule: MD1=Aug 7, winter break after MD17, MD34=May 27 next year
static func _matchday_date(md_num: int, year: int) -> Date:
	var first := Date.new(GameConfig.SEASON_FIRST_MD_DAY, GameConfig.SEASON_FIRST_MD_MONTH, year)
	if md_num <= GameConfig.WINTER_BREAK_AFTER_MD:
		return first.add_days((md_num - 1) * GameConfig.MATCHDAY_INTERVAL_DAYS)
	var md_wb := first.add_days((GameConfig.WINTER_BREAK_AFTER_MD - 1) * GameConfig.MATCHDAY_INTERVAL_DAYS)
	var md_after := md_wb.add_days(GameConfig.WINTER_BREAK_DAYS)
	return md_after.add_days((md_num - GameConfig.WINTER_BREAK_AFTER_MD - 1) * GameConfig.MATCHDAY_INTERVAL_DAYS)


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


func simulate_up_to(target_md: int) -> void:
	for i in range(current_matchday - 1, target_md):
		matchdays[i].simulateMatches()
	current_matchday = mini(target_md + 1, matchdays.size())
	if target_md >= matchdays.size():
		finished = true
