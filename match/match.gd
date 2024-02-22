class_name Match

var homeTeam: Club
var awayTeam: Club
var scoreHome: int = 0
var scoreAway: int = 0 
var played = false

func _init(homeTeamThis: Club, awayTeamThis: Club):
	homeTeam = homeTeamThis
	awayTeam = awayTeamThis 
	

func simulateMatch():
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	scoreHome = rng.randi_range(0,3)
	scoreAway = rng.randi_range(0,3)
	played = true
