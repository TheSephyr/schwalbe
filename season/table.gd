class_name Table

var teamStandings: Array[TeamStanding]
var teams: Array[Club]

func _init(clubs: Array[Club]):
	teams = clubs
	initTable()

	
func initTable():
	teamStandings.clear()
	for n in teams:
		var teamStanding: TeamStanding = TeamStanding.new(n)
		teamStandings.append(teamStanding)

	
func findByTeam(team: Club) -> TeamStanding:
	var foundClub
	for teamStanding in teamStandings:
		if(teamStanding.team == team):
			foundClub = teamStanding 
	return foundClub
		
func update() -> void:
	teamStandings.sort_custom(sortTeamStanding)
	for i: int in teamStandings.size():
		teamStandings[i].currentPosition = i + 1
	
	
func sortTeamStanding(a: TeamStanding, b: TeamStanding) -> bool:
	if a.points > b.points:
		return true 
	else:
		if a.points == b.points:
			if a.goalsDifference > b.goalsDifference:
				return true
			else:
				return false
		return false

