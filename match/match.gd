class_name Match

var homeTeam: Club
var awayTeam: Club
var scoreHome: int = 0
var scoreAway: int = 0
var played: bool   = false

func _init(homeTeamThis: Club, awayTeamThis: Club):
	homeTeam = homeTeamThis
	awayTeam = awayTeamThis


func simulateMatch():
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	scoreHome = rng.randi_range(0,3)
	scoreAway = rng.randi_range(0,3)
	add_match_to_Player(homeTeam)
	add_match_to_Player(awayTeam)
	played = true

func add_match_to_Player(team: Club) -> void:
	for player: Player in team.currentLineUp:
		print_debug("%s Played the game." % player.lastname)
		player.add_match(self)
