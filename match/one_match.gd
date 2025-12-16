class_name OneMatch
extends HBoxContainer

@onready var homeTeamLabel: Label = $HomeTeamLabel
@onready var awayTeamLabel: Label = $AwayTeamLabel
@onready var awayScoreLabel: Label = $AwayScoreLabel
@onready var homeScoreLabel: Label = $HomeScoreLabel

var currentMatch: Match
# Called when the node enters the scene tree for the first time.


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	homeScoreLabel.text = str(currentMatch.scoreHome)
	awayScoreLabel.text = str(currentMatch.scoreAway)
	
	
func initMatch(oneMatch: Match):
	currentMatch = oneMatch
	homeTeamLabel.text = currentMatch.homeTeam.name
	awayTeamLabel.text = currentMatch.awayTeam.name
	homeScoreLabel.text = str(currentMatch.scoreHome)
	awayScoreLabel.text = str(currentMatch.scoreAway)
