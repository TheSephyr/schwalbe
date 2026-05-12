extends Node

const SAVE_PATH = "user://save.json"

var all_clubs: Array[Club]
var first_division_clubs: Array[Club]
var current_season: Season
var player_club: Club
var current_date: Date


func _ready() -> void:
	EventBus.next_matchday.connect(_on_next_matchday)
	EventBus.next.connect(_on_next)


func initial_load() -> void:
	all_clubs = ReadNationFile.loadNationFile("res://dbfiles/LandDeutAllNeu.sav")
	for i in GameConfig.FIRST_DIVISION_SIZE:
		first_division_clubs.append(all_clubs[i])
	for club in first_division_clubs:
		club.defaultLineUp()
	player_club = first_division_clubs[0]
	current_season = Season.new(first_division_clubs)
	current_date = Date.new(1, 7, GameConfig.SEASON_START_YEAR)


func _on_next_matchday() -> void:
	EventBus.emit_update_ui()


func start_new_season() -> void:
	var next_year: int = current_season.start_year + 1
	for club: Club in first_division_clubs:
		for player: Player in club.players:
			player.matches_played = 0
	current_season = Season.new(first_division_clubs, next_year)
	current_date = Date.new(1, 7, next_year)
	save_game()


func _on_next() -> void:
	if current_season.finished:
		return
	var previous_date := current_date
	GameState.last_matchday = current_season.get_current_matchday()
	current_date = GameState.last_matchday.date
	player_club.pay_wages(previous_date.days_until(current_date))
	current_season.simulate_next_matchday()
	EventBus.emit_update_ui()
	save_game()
	if current_season.finished:
		get_tree().change_scene_to_file("res://scenes/season_end/season_end.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/matchday_view.tscn")


# --- Save / Load ---

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func save_game() -> void:
	var data: Dictionary = {
		"player_club_index": first_division_clubs.find(player_club),
		"current_date_day": current_date.day,
		"current_date_month": current_date.month,
		"current_date_year": current_date.year,
		"season_start_year": current_season.start_year,
		"season_current_matchday": current_season.current_matchday,
		"season_finished": current_season.finished,
		"lineup_indices": _get_lineup_indices(),
		"matchday_results": _get_matchday_results(),
		"player_match_counts": _get_player_match_counts(),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK:
		return false
	_apply_save(json.get_data())
	return true


func _get_lineup_indices() -> Array:
	var indices: Array = []
	for player: Player in player_club.currentLineUp:
		indices.append(player_club.players.find(player))
	return indices


func _get_matchday_results() -> Array:
	var results: Array = []
	for matchday: Matchday in current_season.matchdays:
		if matchday.played:
			var scores: Array = []
			for m: Match in matchday.matches:
				scores.append([m.scoreHome, m.scoreAway])
			results.append({"played": true, "scores": scores})
		else:
			results.append({"played": false})
	return results


func _get_player_match_counts() -> Array:
	var counts: Array = []
	for club: Club in first_division_clubs:
		var club_counts: Array = []
		for player: Player in club.players:
			club_counts.append(player.matches_played)
		counts.append(club_counts)
	return counts


func _apply_save(data: Dictionary) -> void:
	player_club = first_division_clubs[int(data["player_club_index"])]
	current_date = Date.new(
		int(data["current_date_day"]),
		int(data["current_date_month"]),
		int(data["current_date_year"])
	)
	var saved_year: int = int(data.get("season_start_year", GameConfig.SEASON_START_YEAR))
	if saved_year != current_season.start_year:
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

	player_club.currentLineUp.clear()
	for idx in data["lineup_indices"]:
		var i: int = int(idx)
		if i >= 0 and i < player_club.players.size():
			player_club.currentLineUp.append(player_club.players[i])

	var counts: Array = data["player_match_counts"]
	for ci: int in counts.size():
		if ci >= first_division_clubs.size():
			break
		var club: Club = first_division_clubs[ci]
		var club_counts: Array = counts[ci]
		for pi: int in club_counts.size():
			if pi < club.players.size():
				club.players[pi].matches_played = int(club_counts[pi])
