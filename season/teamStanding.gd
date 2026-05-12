class_name TeamStanding

var team: Club
var matches: int = 0
var wins: int = 0
var draws: int= 0
var losses: int = 0
var points: int = 0
var goalsFor: int = 0
var goalsAgainst: int = 0
var goalsDifference: int = 0
var currentPosition: int = 1

func _init(teamInit: Club):
	team = teamInit
	
func draw(goalsForUpdate: int, goalsAgainstUpdate: int) -> void:
	draws = draws + 1
	update(goalsForUpdate, goalsAgainstUpdate)
	
func win(goalsForUpdate: int, goalsAgainstUpdate: int) -> void:
	wins = wins + 1
	update(goalsForUpdate, goalsAgainstUpdate)	
	
func loose(goalsForUpdate: int, goalsAgainstUpdate: int) -> void:
	losses = losses + 1
	update(goalsForUpdate, goalsAgainstUpdate)
	
func update(goalsForUpdate: int, goalsAgainstUpdate: int) -> void:
	matches = matches + 1
	updateGoals(goalsForUpdate, goalsAgainstUpdate)
	updatePoints()

func updateGoals(goalsForUpdate: int, goalsAgainstUpdate: int) -> void:
	goalsFor = goalsFor + goalsForUpdate
	goalsAgainst = goalsAgainst + goalsAgainstUpdate
	
func updatePoints() -> void:
	points = wins * GameConfig.POINTS_FOR_WIN + draws * GameConfig.POINTS_FOR_DRAW
	goalsDifference = goalsFor - goalsAgainst
