extends Control

@onready var my_team_name: Label = $Margin/VBox/ScoreRow/MyTeamName
@onready var score_label: Label = $Margin/VBox/ScoreRow/Score
@onready var opponent_name: Label = $Margin/VBox/ScoreRow/OpponentName
@onready var my_lineup: VBoxContainer = $Margin/VBox/LineupsRow/MyColumn/Scroll/MyLineup
@onready var opponent_lineup: VBoxContainer = $Margin/VBox/LineupsRow/OpponentColumn/Scroll/OpponentLineup


func _ready() -> void:
	var matchday: Matchday = GameState.last_matchday
	var my_match: Match = _find_my_match(matchday)
	if my_match == null:
		return

	var is_home: bool = my_match.homeTeam == Game.player_club
	var opponent: Club = my_match.awayTeam if is_home else my_match.homeTeam
	var my_score: int = my_match.scoreHome if is_home else my_match.scoreAway
	var opp_score: int = my_match.scoreAway if is_home else my_match.scoreHome

	my_team_name.text = Game.player_club.name
	opponent_name.text = opponent.name
	score_label.text = str(my_score) + " : " + str(opp_score)

	for player: Player in Game.player_club.currentLineUp:
		my_lineup.add_child(_player_label(player))

	for player: Player in opponent.currentLineUp:
		opponent_lineup.add_child(_player_label(player))


func _find_my_match(matchday: Matchday) -> Match:
	for m: Match in matchday.matches:
		if m.homeTeam == Game.player_club or m.awayTeam == Game.player_club:
			return m
	return null


func _player_label(player: Player) -> Label:
	var label := Label.new()
	label.text = player.position_label() + "  " + player.lastname + ", " + player.firstname
	return label


func _on_continue_pressed() -> void:
	if Game.current_season.current_matchday == GameConfig.WINTER_BREAK_AFTER_MD + 1:
		get_tree().change_scene_to_file("res://scenes/player_update/player_update_scene.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/club_overview.tscn")
