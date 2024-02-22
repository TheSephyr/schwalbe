class_name SingleTableEntryScene
extends HBoxContainer

@onready var positionLabel: Label = $Position
@onready var nameLabel: Label = $Name
@onready var pointsLabel: Label = $Points
@onready var winsLabel: Label = $Wins
@onready var drawsLabel: Label = $Draws
@onready var loosesLabel: Label = $Looses
var teamStanding: TeamStanding

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setTeamstanding(teamStandingUpdate: TeamStanding):
	teamStanding = teamStandingUpdate
	positionLabel.text = str(teamStanding.currentPosition)
	nameLabel.text = teamStanding.team.name
	pointsLabel.text = str(teamStanding.points)
	winsLabel.text = str(teamStanding.wins)
	drawsLabel.text = str(teamStanding.draws)
	loosesLabel.text = str(teamStanding.losses)
