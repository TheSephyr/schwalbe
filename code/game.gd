extends Node

const SAVE_DIR = "user://saves/"

var all_clubs: Array[Club]
var first_division_clubs: Array[Club]
var free_agents: Array[Player] = []
var reporters: Array[Reporter] = []
var referees: Array[Referee] = []
var celebrities: Array[Celebrity] = []
var sponsors: Array[Sponsor] = []
var current_season: Season
var player_club: Club
var current_date: Date
var training_plan: Array[int] = []

var sponsor_name: String = ""
var sponsor_income: int = 0

var trainer_lastname: String = ""
var trainer_firstname: String = ""
var trainer_birthdate: String = ""
var trainer_competence: int = 0
var trainer_reputation: TrainerReputationTypes.Reputation = TrainerReputationTypes.Reputation.NONE

var pending_transfers: Array[Dictionary] = []
var active_negotiations: Array[Dictionary] = []

var _preview_remaining_days: int = 0


func _ready() -> void:
	EventBus.next_matchday.connect(_on_next_matchday)
	EventBus.next.connect(_on_next)


func initial_load() -> void:
	free_agents.clear()
	var nation_data := ReadNationFile.loadNationFile("res://dbfiles/LandDeut.sav")
	all_clubs.assign(nation_data["clubs"])
	reporters.assign(nation_data["reporters"])
	referees.assign(nation_data["referees"])
	celebrities.assign(nation_data["celebrities"])
	sponsors.assign(nation_data["sponsors"])
	for i in GameConfig.FIRST_DIVISION_SIZE:
		first_division_clubs.append(all_clubs[i])
	for club in first_division_clubs:
		club.defaultLineUp()
	player_club = first_division_clubs[0]
	current_season = Season.new(first_division_clubs)
	current_date = Date.new(1, 7, GameConfig.SEASON_START_YEAR)
	_init_training_plan()
	_generate_free_agents()
	_record_ability_snapshot("Saisonstart %d" % GameConfig.SEASON_START_YEAR)


func _on_next_matchday() -> void:
	EventBus.emit_update_ui()


func start_new_season() -> void:
	_apply_pending_transfers()
	var next_year: int = current_season.start_year + 1
	_ai_renew_contracts(next_year)
	_remove_expired_contracts(current_season.start_year)
	_retire_free_agents(next_year)
	_ai_fill_squads(next_year)
	for club: Club in first_division_clubs:
		for player: Player in club.players:
			player.matches_played = 0
	current_season = Season.new(first_division_clubs, next_year)
	current_date = Date.new(1, 7, next_year)
	_init_training_plan()
	_record_ability_snapshot("Saisonstart %d" % next_year)
	save_game("Autosave")


func _ai_renew_contracts(season_end_year: int) -> void:
	for club: Club in first_division_clubs:
		if club == player_club:
			continue
		for player: Player in club.players:
			var parts := player.contract_end.split(".")
			if parts.size() < 3:
				continue
			if parts[2].to_int() > season_end_year:
				continue
			if randf() < GameConfig.AI_CONTRACT_RENEWAL_CHANCE:
				var new_years := randi_range(1, 3)
				player.contract_end = "30.06.%d" % (season_end_year + new_years)
				player.salary = mini(GameConfig.CONTRACT_MAX_SALARY,
					int(player.salary * randf_range(1.0, 1.15)))


func _ai_fill_squads(season_end_year: int) -> void:
	# pos -> [min, max]
	var requirements: Dictionary = {
		"1":  [2, 3],  # GK
		"3":  [3, 4],  # CB
		"4":  [1, 2],  # LB
		"5":  [1, 2],  # RB
		"7":  [1, 2],  # LM
		"8":  [1, 2],  # RM
		"2":  [0, 2],  # LI
		"6":  [0, 2],  # CDM
		"9":  [1, 2],  # CM
		"10": [2, 3],  # ST
	}

	for club: Club in first_division_clubs:
		if club == player_club:
			continue
		if club.players.size() >= 22:
			continue

		var counts: Dictionary = {}
		for player: Player in club.players:
			counts[player.position] = counts.get(player.position, 0) + 1

		var signed_any := false

		# First pass: fill positions below their minimum
		for pos: String in requirements:
			var shortage: int = requirements[pos][0] - counts.get(pos, 0)
			for i in shortage:
				if club.players.size() >= 22:
					break
				var candidate := _best_free_agent_for_position(pos)
				if candidate == null:
					break
				_sign_free_agent_for_ai(club, candidate, season_end_year)
				counts[pos] = counts.get(pos, 0) + 1
				signed_any = true

		# Second pass: fill up to max per position until squad reaches 22
		for pos: String in requirements:
			if club.players.size() >= 22:
				break
			while counts.get(pos, 0) < requirements[pos][1] and club.players.size() < 22:
				var candidate := _best_free_agent_for_position(pos)
				if candidate == null:
					break
				_sign_free_agent_for_ai(club, candidate, season_end_year)
				counts[pos] = counts.get(pos, 0) + 1
				signed_any = true

		if signed_any:
			club.currentLineUp.clear()
			club.defaultLineUp()


func _sign_free_agent_for_ai(club: Club, player: Player, season_end_year: int) -> void:
	free_agents.erase(player)
	player.contract_end = "30.06.%d" % (season_end_year + randi_range(1, 3))
	club.players.append(player)


func _best_free_agent_for_position(position: String) -> Player:
	var best: Player = null
	var best_ability := -1
	for player: Player in free_agents:
		if player.position == position:
			var ability := player.currentAbility.to_int()
			if ability > best_ability:
				best_ability = ability
				best = player
	return best


func _remove_expired_contracts(season_start_year: int) -> void:
	var end_year: int = season_start_year + 1
	for club: Club in first_division_clubs:
		var remaining: Array[Player] = []
		for player: Player in club.players:
			var parts := player.contract_end.split(".")
			if parts.size() < 3 or parts[2].to_int() > end_year:
				remaining.append(player)
			elif _should_retire(player, end_year):
				pass
			else:
				free_agents.append(player)
		club.players = remaining
		club.currentLineUp.clear()
		club.defaultLineUp()


func _retire_free_agents(current_year: int) -> void:
	var remaining: Array[Player] = []
	for player: Player in free_agents:
		if not _should_retire(player, current_year):
			remaining.append(player)
	free_agents = remaining


func _should_retire(player: Player, current_year: int) -> bool:
	var parts := player.birthdate.split(".")
	if parts.size() < 3:
		return false
	var age := current_year - parts[2].to_int()
	if age < GameConfig.RETIREMENT_MIN_AGE:
		return false
	var chance := clampf(
		(age - GameConfig.RETIREMENT_MIN_AGE) * GameConfig.RETIREMENT_CHANCE_PER_YEAR + GameConfig.RETIREMENT_BASE_CHANCE,
		0.0, GameConfig.RETIREMENT_MAX_CHANCE
	)
	return randf() < chance


func _on_next() -> void:
	if current_season.finished:
		return

	var next_md: Matchday = current_season.get_current_matchday()
	var days_to_md: int = current_date.days_until(next_md.date)

	var season_start := Date.new(1, 7, current_season.start_year)
	var week_index: int = season_start.days_until(current_date) / 7

	if days_to_md <= 7:
		# Matchday falls within this week — pay wages up to match day,
		# apply training, then hand off to the preview scene.
		_pay_all_wages(maxi(0, days_to_md))
		_apply_training(week_index)
		_preview_remaining_days = 7 - maxi(0, days_to_md)
		get_tree().change_scene_to_file("res://scenes/match_preview/match_preview_scene.tscn")
	else:
		# No matchday this week — advance 7 days
		_pay_all_wages(7)
		_apply_training(week_index)
		current_date = current_date.add_days(7)
		_process_negotiations()
		EventBus.emit_update_ui()
		save_game("Autosave")


func confirm_matchday_simulation() -> void:
	var next_md := current_season.get_current_matchday()
	current_season.simulate_next_matchday()
	if _preview_remaining_days > 0:
		_pay_all_wages(_preview_remaining_days)
	current_date = current_date.add_days(7)
	_process_negotiations()
	GameState.last_matchday = next_md
	EventBus.emit_update_ui()
	save_game("Autosave")
	if current_season.finished:
		get_tree().change_scene_to_file("res://scenes/season_end/season_end.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/matchday_view.tscn")


func _pay_all_wages(days: int) -> void:
	for club: Club in first_division_clubs:
		club.pay_wages(days)


func _init_training_plan() -> void:
	var season_start := Date.new(1, 7, current_season.start_year)
	var last_md: Matchday = current_season.matchdays.back()
	var total_weeks: int = int(ceil(season_start.days_until(last_md.date) / 7.0)) + 1
	training_plan.resize(total_weeks)
	training_plan.fill(GameConfig.TRAINING_TYPE_NONE)


func _apply_training(week_index: int) -> void:
	var player_type: int = training_plan[week_index] if week_index >= 0 and week_index < training_plan.size() else GameConfig.TRAINING_TYPE_NONE
	_apply_training_to_club(player_club, player_type)
	for club: Club in first_division_clubs:
		if club == player_club:
			continue
		_apply_training_to_club(club, randi_range(GameConfig.TRAINING_TYPE_CONDITION, GameConfig.TRAINING_TYPE_REGEN))
	_apply_individual_training()


func _apply_individual_training() -> void:
	for player: Player in player_club.players:
		if player.training_skill == 0:
			continue
		player.training_progress += 1.0 / GameConfig.INDIVIDUAL_TRAINING_WEEKS
		if player.training_progress >= 1.0:
			_complete_individual_training(player)


func _complete_individual_training(player: Player) -> void:
	if player.position == "1":
		var skill := player.training_skill as GoalkeeperSkillTypes.Skill
		if not player.gk_positive_skills.has(skill):
			player.gk_positive_skills.append(skill)
	else:
		var skill := player.training_skill as PlayerSkillTypes.Skill
		if not player.positive_skills.has(skill):
			player.positive_skills.append(skill)
	player.training_skill = 0
	player.training_progress = 0.0


func _apply_training_to_club(club: Club, type: int) -> void:
	for player: Player in club.players:
		match type:
			GameConfig.TRAINING_TYPE_CONDITION:
				player.condition = mini(GameConfig.MAX_CONDITION, player.condition + GameConfig.TRAINING_CONDITION_GAIN)
				player.freshness = maxi(GameConfig.MIN_FRESHNESS, player.freshness - GameConfig.TRAINING_CONDITION_FRESHNESS_LOSS)
			GameConfig.TRAINING_TYPE_REGEN:
				player.freshness = mini(GameConfig.MAX_FRESHNESS, player.freshness + GameConfig.TRAINING_REGEN_FRESHNESS_GAIN)
				player.condition = maxi(GameConfig.MIN_CONDITION, player.condition - GameConfig.TRAINING_REGEN_CONDITION_LOSS)


# --- Ability history ---

func _record_ability_snapshot(label: String) -> void:
	for club: Club in all_clubs:
		for p: Player in club.players:
			p.ability_history.append({"label": label, "ability": p.currentAbility.to_int()})
	for p: Player in free_agents:
		p.ability_history.append({"label": label, "ability": p.currentAbility.to_int()})


# --- Free agent generation ---

func _generate_free_agents() -> void:
	var firstnames := _load_lines("res://files/firstnames_male.txt")
	var lastnames := _load_lines("res://files/lastnames.txt")
	if firstnames.is_empty() or lastnames.is_empty():
		return
	for i in GameConfig.GENERATED_FREE_AGENT_COUNT:
		var p := Player.new()
		p.firstname = firstnames[randi() % firstnames.size()]
		p.lastname = lastnames[randi() % lastnames.size()]
		var age := randi_range(16, 35)
		var birth_year := GameConfig.SEASON_START_YEAR - age
		p.birthdate = "01.07.%d" % birth_year
		p.position = str(randi_range(1, 10))
		p.talent = str(randi_range(1, GameConfig.FREE_AGENT_MAX_TALENT))
		p.currentAbility = str(randi_range(1, GameConfig.FREE_AGENT_MAX_ABILITY))
		p.generate_contract()
		p.contract_end = "30.06.%d" % GameConfig.SEASON_START_YEAR
		free_agents.append(p)


func _load_lines(path: String) -> Array[String]:
	var lines: Array[String] = []
	if not FileAccess.file_exists(path):
		return lines
	var file := FileAccess.open(path, FileAccess.READ)
	while not file.eof_reached():
		var line := file.get_line().strip_edges()
		if not line.is_empty():
			lines.append(line)
	file.close()
	return lines


# --- Transfer market ---

func days_until_contract_end(player: Player) -> int:
	var parts := player.contract_end.split(".")
	if parts.size() < 3:
		return 9999
	var end_date := Date.new(int(parts[0]), int(parts[1]), int(parts[2]))
	return current_date.days_until(end_date)


func sign_player_immediately(player: Player, from_club: Club, salary: int, auflauf: int, tor: int, contract_end_year: int) -> void:
	if from_club != null:
		from_club.players.erase(player)
		from_club.currentLineUp.erase(player)
		from_club.defaultLineUp()
	else:
		free_agents.erase(player)
	player.salary = salary
	player.auflauf_praemie = auflauf
	player.tor_praemie = tor
	player.contract_end = "30.06.%d" % contract_end_year
	player_club.players.append(player)


func start_transfer_negotiation(player: Player, from_club: Club, salary: int, auflauf: int, tor: int, contract_end_year: int, fee: int) -> void:
	player.negotiating = true
	var deadline := current_date.add_days(GameConfig.TRANSFER_NEGOTIATION_DAYS)
	active_negotiations.append({
		"player": player,
		"from_club": from_club,
		"deadline_day": deadline.day,
		"deadline_month": deadline.month,
		"deadline_year": deadline.year,
		"offers": [{
			"to_club": player_club,
			"salary": salary,
			"auflauf": auflauf,
			"tor": tor,
			"contract_end_year": contract_end_year,
			"fee": fee,
		}],
	})


func _process_negotiations() -> void:
	_add_ai_negotiation_offers()
	var remaining: Array[Dictionary] = []
	for neg: Dictionary in active_negotiations:
		var deadline := Date.new(int(neg["deadline_day"]), int(neg["deadline_month"]), int(neg["deadline_year"]))
		if current_date.days_until(deadline) <= 0:
			_resolve_negotiation(neg)
		else:
			remaining.append(neg)
	active_negotiations = remaining


func _add_ai_negotiation_offers() -> void:
	for neg: Dictionary in active_negotiations:
		if randf() > GameConfig.AI_NEGOTIATION_OFFER_CHANCE:
			continue
		var player: Player = neg["player"]
		var from_club: Club = neg["from_club"]
		var offers: Array = neg["offers"]
		var clubs_with_offers: Array = []
		for offer: Dictionary in offers:
			clubs_with_offers.append(offer["to_club"])
		var candidates: Array[Club] = []
		for club: Club in first_division_clubs:
			if club == player_club or club == from_club:
				continue
			if club in clubs_with_offers:
				continue
			candidates.append(club)
		if candidates.is_empty():
			continue
		var bidder: Club = candidates[randi() % candidates.size()]
		offers.append({
			"to_club": bidder,
			"salary": int(player.salary * randf_range(0.9, 1.4)),
			"auflauf": player.auflauf_praemie,
			"tor": player.tor_praemie,
			"contract_end_year": current_season.start_year + 1 + randi_range(1, 3),
			"fee": int(player.market_value * randf_range(0.7, 1.2)),
		})


func _resolve_negotiation(neg: Dictionary) -> void:
	var player: Player = neg["player"]
	player.negotiating = false
	var from_club: Club = neg["from_club"]
	var offers: Array = neg["offers"]
	if offers.is_empty():
		return
	var best: Dictionary = offers[0]
	for offer: Dictionary in offers:
		if int(offer["salary"]) > int(best["salary"]):
			best = offer
	var winner: Club = best["to_club"]
	if from_club != null:
		from_club.players.erase(player)
		from_club.currentLineUp.erase(player)
		from_club.defaultLineUp()
	player.salary = int(best["salary"])
	player.auflauf_praemie = int(best["auflauf"])
	player.tor_praemie = int(best["tor"])
	player.contract_end = "30.06.%d" % int(best["contract_end_year"])
	winner.players.append(player)
	winner.currentLineUp.clear()
	winner.defaultLineUp()
	GameState.transfer_results.append({
		"player_name": player.firstname + " " + player.lastname,
		"from_club": from_club.name if from_club != null else "Vereinslos",
		"to_club": winner.name,
		"won_by_player": winner == player_club,
	})
	while GameState.transfer_results.size() > 10:
		GameState.transfer_results.pop_front()


func add_pending_transfer(player: Player, from_club: Club, salary: int, auflauf: int, tor: int, contract_end_year: int) -> void:
	pending_transfers.append({
		"player": player,
		"from_club": from_club,
		"salary": salary,
		"auflauf": auflauf,
		"tor": tor,
		"contract_end_year": contract_end_year,
	})


func _apply_pending_transfers() -> void:
	for t: Dictionary in pending_transfers:
		var p: Player = t["player"]
		var fc: Club = t["from_club"]
		if fc != null:
			fc.players.erase(p)
			fc.currentLineUp.erase(p)
			fc.defaultLineUp()
		p.salary = t["salary"]
		p.auflauf_praemie = t["auflauf"]
		p.tor_praemie = t["tor"]
		p.contract_end = "30.06.%d" % t["contract_end_year"]
		player_club.players.append(p)
	pending_transfers.clear()


# --- Save / Load ---

func has_any_save() -> bool:
	return not list_saves().is_empty()


func list_saves() -> Array[String]:
	var saves: Array[String] = []
	var dir := DirAccess.open(SAVE_DIR)
	if dir == null:
		return saves
	dir.list_dir_begin()
	var filename := dir.get_next()
	while filename != "":
		if filename.ends_with(".json"):
			saves.append(filename.trim_suffix(".json"))
		filename = dir.get_next()
	saves.sort()
	return saves


func save_game(save_name: String) -> void:
	var clubs_data: Array = []
	for club: Club in first_division_clubs:
		clubs_data.append(_serialize_club(club))

	var matchday_results: Array = []
	for matchday: Matchday in current_season.matchdays:
		if matchday.played:
			var scores: Array = []
			for m: Match in matchday.matches:
				scores.append([m.scoreHome, m.scoreAway])
			matchday_results.append({"played": true, "scores": scores})
		else:
			matchday_results.append({"played": false})

	var dt := Time.get_datetime_dict_from_system()
	var saved_at := "%02d.%02d.%04d %02d:%02d" % [dt["day"], dt["month"], dt["year"], dt["hour"], dt["minute"]]

	var free_agents_data: Array = []
	for player: Player in free_agents:
		free_agents_data.append(_serialize_player(player))

	var data: Dictionary = {
		"saved_at": saved_at,
		"player_club_name": player_club.name,
		"sponsor_name": sponsor_name,
		"sponsor_income": sponsor_income,
		"trainer_lastname": trainer_lastname,
		"trainer_firstname": trainer_firstname,
		"trainer_birthdate": trainer_birthdate,
		"trainer_competence": trainer_competence,
		"trainer_reputation": trainer_reputation,
		"player_club_index": first_division_clubs.find(player_club),
		"current_date_day": current_date.day,
		"current_date_month": current_date.month,
		"current_date_year": current_date.year,
		"season_start_year": current_season.start_year,
		"season_current_matchday": current_season.current_matchday,
		"season_finished": current_season.finished,
		"training_plan": training_plan,
		"clubs": clubs_data,
		"free_agents": free_agents_data,
		"matchday_results": matchday_results,
		"pending_transfers": _serialize_pending_transfers(),
		"active_negotiations": _serialize_negotiations(),
	}
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	var path := SAVE_DIR + save_name + ".json"
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


func load_game(save_name: String) -> bool:
	var path := SAVE_DIR + save_name + ".json"
	if not FileAccess.file_exists(path):
		return false
	var file := FileAccess.open(path, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK:
		return false
	_apply_save(json.get_data())
	return true


func _serialize_player(player: Player) -> Dictionary:
	return {
		"lastname": player.lastname,
		"firstname": player.firstname,
		"birthdate": player.birthdate,
		"position": player.position,
		"talent": player.talent,
		"currentAbility": player.currentAbility,
		"salary": player.salary,
		"auflauf_praemie": player.auflauf_praemie,
		"tor_praemie": player.tor_praemie,
		"market_value": player.market_value,
		"contract_end": player.contract_end,
		"condition": player.condition,
		"freshness": player.freshness,
		"matches_played": player.matches_played,
		"ability_history": player.ability_history,
		"negotiating": player.negotiating,
		"training_skill": player.training_skill,
		"training_progress": player.training_progress,
	}


func _deserialize_player(data: Dictionary) -> Player:
	var p := Player.new()
	p.lastname = data["lastname"]
	p.firstname = data["firstname"]
	p.birthdate = data["birthdate"]
	p.position = data["position"]
	p.talent = data["talent"]
	p.currentAbility = data["currentAbility"]
	p.salary = int(data["salary"])
	p.auflauf_praemie = int(data["auflauf_praemie"])
	p.tor_praemie = int(data.get("tor_praemie", 0))
	p.market_value = int(data["market_value"])
	p.contract_end = data["contract_end"]
	p.condition = int(data.get("condition", 50))
	p.freshness = int(data.get("freshness", 50))
	p.matches_played = int(data.get("matches_played", 0))
	var raw_history: Array = data.get("ability_history", [])
	for entry: Variant in raw_history:
		p.ability_history.append(entry as Dictionary)
	p.negotiating = bool(data.get("negotiating", false))
	p.training_skill = int(data.get("training_skill", 0))
	p.training_progress = float(data.get("training_progress", 0.0))
	return p


func _serialize_club(club: Club) -> Dictionary:
	var players_data: Array = []
	for player: Player in club.players:
		players_data.append(_serialize_player(player))

	var lineup_indices: Array = []
	for player: Player in club.currentLineUp:
		lineup_indices.append(club.players.find(player))

	var data: Dictionary = {
		"name": club.name,
		"nation": club.nation,
		"money": club.money,
		"players": players_data,
		"lineup_indices": lineup_indices,
		"spielstil": club.spielstil,
		"pressing": club.pressing,
	}
	if club.manager != null:
		data["manager_lastname"] = club.manager.lastname
		data["manager_firstname"] = club.manager.firstname
		data["manager_birthdate"] = club.manager.birthdate
		data["manager_competence"] = club.manager.competence
	if club.trainer != null:
		data["trainer_lastname"] = club.trainer.lastname
		data["trainer_firstname"] = club.trainer.firstname
		data["trainer_birthdate"] = club.trainer.birthdate
		data["trainer_competence"] = club.trainer.competence
		data["trainer_reputation"] = club.trainer.reputation
	if club.stadium != null:
		data["stadium_name"] = club.stadium.name
		data["stadium_city"] = club.stadium.city
		data["stadium_north"] = club.stadium.north
		data["stadium_south"] = club.stadium.south
		data["stadium_west"] = club.stadium.west
		data["stadium_east"] = club.stadium.east
		data["stadium_ticket_price"] = club.stadium.ticket_price
	return data


func _deserialize_club(data: Dictionary) -> Club:
	var club := Club.new()
	club.name = data["name"]
	club.nation = data.get("nation", "")
	club.money = int(data["money"])
	club.spielstil = int(data.get("spielstil", GameConfig.SPIELSTIL_AUSGEWOGEN))
	club.pressing = int(data.get("pressing", GameConfig.PRESSING_MITTEL))

	for pd: Dictionary in data["players"]:
		club.players.append(_deserialize_player(pd))

	for idx: Variant in data.get("lineup_indices", []):
		var i := int(idx)
		if i >= 0 and i < club.players.size():
			club.currentLineUp.append(club.players[i])

	if data.has("manager_lastname"):
		club.manager = Manager.new(
			data["manager_lastname"],
			data["manager_firstname"],
			data.get("manager_birthdate", "")
		)
		club.manager.competence = data.get("manager_competence", 0)
	if data.has("trainer_lastname"):
		club.trainer = Trainer.new(
			data["trainer_lastname"],
			data["trainer_firstname"],
			data.get("trainer_birthdate", "")
		)
		club.trainer.competence = data.get("trainer_competence", 0)
		club.trainer.reputation = data.get("trainer_reputation", TrainerReputationTypes.Reputation.NONE)
	if data.has("stadium_name"):
		var st := Stadium.new()
		st.name = data["stadium_name"]
		st.city = data["stadium_city"]
		st.north = int(data["stadium_north"])
		st.south = int(data["stadium_south"])
		st.west = int(data["stadium_west"])
		st.east = int(data["stadium_east"])
		st.ticket_price = int(data.get("stadium_ticket_price", GameConfig.TICKET_PRICE_DEFAULT))
		club.stadium = st
	return club


func _apply_save(data: Dictionary) -> void:
	first_division_clubs.clear()
	all_clubs.clear()
	for cd: Dictionary in data["clubs"]:
		var club := _deserialize_club(cd)
		first_division_clubs.append(club)
		all_clubs.append(club)

	sponsor_name = data.get("sponsor_name", "")
	sponsor_income = int(data.get("sponsor_income", 0))
	trainer_lastname = data.get("trainer_lastname", "")
	trainer_firstname = data.get("trainer_firstname", "")
	trainer_birthdate = data.get("trainer_birthdate", "")
	trainer_competence = data.get("trainer_competence", 0)
	trainer_reputation = data.get("trainer_reputation", TrainerReputationTypes.Reputation.NONE)

	player_club = first_division_clubs[int(data["player_club_index"])]
	if not trainer_lastname.is_empty():
		player_club.trainer = Trainer.new(trainer_lastname, trainer_firstname, trainer_birthdate)
		player_club.trainer.competence = trainer_competence
		player_club.trainer.reputation = trainer_reputation

	current_date = Date.new(
		int(data["current_date_day"]),
		int(data["current_date_month"]),
		int(data["current_date_year"])
	)

	var saved_year: int = int(data.get("season_start_year", GameConfig.SEASON_START_YEAR))
	current_season = Season.new(first_division_clubs, saved_year)
	current_season.current_matchday = int(data["season_current_matchday"])
	current_season.finished = bool(data["season_finished"])

	var md_results: Array = data["matchday_results"]
	for i: int in md_results.size():
		var md_data: Dictionary = md_results[i]
		if md_data["played"]:
			var matchday: Matchday = current_season.matchdays[i]
			matchday.played = true
			var scores: Array = md_data["scores"]
			for j: int in matchday.matches.size():
				var m: Match = matchday.matches[j]
				m.scoreHome = int(scores[j][0])
				m.scoreAway = int(scores[j][1])
				m.played = true

	current_season.update_table()

	free_agents.clear()
	for pd: Dictionary in data.get("free_agents", []):
		free_agents.append(_deserialize_player(pd))

	_init_training_plan()
	if data.has("training_plan"):
		var saved_plan: Array = data["training_plan"]
		for i: int in mini(saved_plan.size(), training_plan.size()):
			training_plan[i] = int(saved_plan[i])

	pending_transfers.clear()
	for td: Dictionary in data.get("pending_transfers", []):
		_deserialize_pending_transfer(td)

	_deserialize_negotiations(data.get("active_negotiations", []))


func _serialize_pending_transfers() -> Array:
	var result: Array = []
	for t: Dictionary in pending_transfers:
		var p: Player = t["player"]
		var fc: Club = t["from_club"]
		result.append({
			"from_club_name": fc.name if fc != null else "",
			"player_lastname": p.lastname,
			"player_firstname": p.firstname,
			"player_birthdate": p.birthdate,
			"salary": t["salary"],
			"auflauf": t["auflauf"],
			"tor": t["tor"],
			"contract_end_year": t["contract_end_year"],
		})
	return result


func _serialize_negotiations() -> Array:
	var result: Array = []
	for neg: Dictionary in active_negotiations:
		var player: Player = neg["player"]
		var from_club: Club = neg["from_club"]
		var offers_data: Array = []
		for offer: Dictionary in neg["offers"]:
			var to_club: Club = offer["to_club"]
			offers_data.append({
				"to_club_name": to_club.name if to_club != null else "",
				"salary": offer["salary"],
				"auflauf": offer["auflauf"],
				"tor": offer["tor"],
				"contract_end_year": offer["contract_end_year"],
				"fee": offer.get("fee", 0),
			})
		result.append({
			"player_lastname": player.lastname,
			"player_firstname": player.firstname,
			"player_birthdate": player.birthdate,
			"from_club_name": from_club.name if from_club != null else "",
			"deadline_day": neg["deadline_day"],
			"deadline_month": neg["deadline_month"],
			"deadline_year": neg["deadline_year"],
			"offers": offers_data,
		})
	return result


func _deserialize_negotiations(data: Array) -> void:
	active_negotiations.clear()
	for neg_data: Dictionary in data:
		var from_club_name: String = neg_data.get("from_club_name", "")
		var from_club: Club = null
		for club: Club in first_division_clubs:
			if club.name == from_club_name:
				from_club = club
				break
		if from_club == null:
			continue
		var player: Player = null
		for p: Player in from_club.players:
			if p.lastname == neg_data["player_lastname"] and p.birthdate == neg_data["player_birthdate"]:
				player = p
				break
		if player == null:
			continue
		player.negotiating = true
		var offers: Array = []
		for offer_data: Dictionary in neg_data.get("offers", []):
			var to_club_name: String = offer_data.get("to_club_name", "")
			var to_club: Club = player_club
			for club: Club in first_division_clubs:
				if club.name == to_club_name:
					to_club = club
					break
			offers.append({
				"to_club": to_club,
				"salary": int(offer_data["salary"]),
				"auflauf": int(offer_data["auflauf"]),
				"tor": int(offer_data["tor"]),
				"contract_end_year": int(offer_data["contract_end_year"]),
				"fee": int(offer_data.get("fee", 0)),
			})
		active_negotiations.append({
			"player": player,
			"from_club": from_club,
			"deadline_day": int(neg_data["deadline_day"]),
			"deadline_month": int(neg_data["deadline_month"]),
			"deadline_year": int(neg_data["deadline_year"]),
			"offers": offers,
		})


func _deserialize_pending_transfer(data: Dictionary) -> void:
	var from_club_name: String = data.get("from_club_name", "")
	var from_club: Club = null
	var player: Player = null
	for club: Club in first_division_clubs:
		if club.name == from_club_name:
			from_club = club
			break
	if from_club != null:
		for p: Player in from_club.players:
			if p.lastname == data["player_lastname"] and p.birthdate == data["player_birthdate"]:
				player = p
				break
	if player == null or from_club == null:
		return
	pending_transfers.append({
		"player": player,
		"from_club": from_club,
		"salary": int(data["salary"]),
		"auflauf": int(data["auflauf"]),
		"tor": int(data["tor"]),
		"contract_end_year": int(data["contract_end_year"]),
	})
