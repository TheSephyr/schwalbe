class_name SingleMatch

extends Control

var singleMatch: Match

@onready var homeTeamLabel: Label = get_node("HomeTeam")
@onready var awayTeamLabel: Label = get_node("AwayTeam")
@onready var awayScoreLabel: Label = get_node("AwayScore")
@onready var homeScoreLabel: Label = get_node("HomeScore")

#func _init(homeTeam: Club, awayTeam: Club):
#	homeTeam = homeTeam
#	awayTeam = awayTeam
#	scoreHome = 0
#	scoreHome = 0

func setMatch(singleMatchThis: Match):
	singleMatch = singleMatchThis
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	homeTeamLabel.text = singleMatch.homeTeam.name
	awayTeamLabel.text = singleMatch.awayTeam.name
	pass # Replace with function body.


func _on_simulate_button_down():
	var rng = RandomNumberGenerator.new()
	var homeScore= rng.randi_range(0,3)
	var awayScore = rng.randi_range(0,3)
	awayScoreLabel.text = str(awayScore)
	homeScoreLabel.text = str(homeScore)
	pass # Replace with function body.
