class_name ReadNationFile

const PLAYER_MARKER_START: String = "%SECT%SPIELER"
const PLAYER_MARKER_END: String = "%ENDSECT%SPIELER"

const CLUB_MARKER_START: String = "%SECT%VEREIN"
const CLUB_MARKER_END: String = "%ENDSECT%VEREIN"

const COACH_MARKER_START: String = "%SECT%TRAINER"
const COACH_MARKER_END: String = "%ENDSECT%TRAINER"

const MANAGER_MARKER_START: String = "%SECT%MANAGER"
const MANAGER_MARKER_END: String = "%ENDSECT%MANAGER"

const NATION_MARKER_START: String = "%SECT%LAND"

const STADION_MARKER_START: String = "%SECT%STADION"
const STADION_MARKER_END: String = "%ENDSECT%STADION"


# Called when the node enters the scene tree for the first time.
#"res://LandDeutAllNeu.sav"
static func loadNationFile(nationFile: String) -> Array[Club]:
	var allPlayer: Array[Player]
	var all_clubs: Array[Club]
	var player_instance: Player
	var file = FileAccess.open(nationFile, FileAccess.READ)
	var fileContent = file.get_as_text()
	#print_debug(file.get_as_text())
	var readingPlayer: bool = false
	var readingClub: bool = false
	var readingCoach: bool = false
	var readingManager: bool = false
	var readingStadion: bool = false
	var lineCounterPlayer: int = 1;
	var lineCounterClub: int = 1;
	var lineCounterCoach: int = 1;
	var lineCounterManager: int = 1;
	var newPlayer: Player
	var newClub: Club
	
	while !file.eof_reached():
		var line = file.get_line()
		if(line.begins_with("%")):
			match(line):
				PLAYER_MARKER_START:
					readingPlayer = true
					newPlayer = Player.new()
				PLAYER_MARKER_END:
					allPlayer.append(newPlayer)
					lineCounterPlayer = 1
					readingPlayer = false
				CLUB_MARKER_START:
					readingClub = true
					newClub = Club.new()
					allPlayer = []
				CLUB_MARKER_END:
					readingClub = false
					newClub.players = allPlayer
					lineCounterClub = 1
					all_clubs.append(newClub)
				COACH_MARKER_START:
					readingCoach = true
				COACH_MARKER_END:
					readingCoach = false
				MANAGER_MARKER_START:
					readingManager = true
				MANAGER_MARKER_END:
					readingManager = false
				STADION_MARKER_START:
					readingStadion = true
				STADION_MARKER_END:
					readingStadion = false
				#_:
					#print("Could not find: " + line)
		else:
			if readingClub:
				match(lineCounterClub):
					1:
						newClub.nation = line
					2:
						newClub.name = line
				lineCounterClub = lineCounterClub + 1
			if readingPlayer:
				match(lineCounterPlayer):
					1:
						newPlayer.lastname = line
					2:
						newPlayer.firstname = line
					7:
						newPlayer.currentAbility = line
					9:
						newPlayer.position = line
					19:
						newPlayer.talent = line
					22:
						newPlayer.birthdate = line
				lineCounterPlayer = lineCounterPlayer + 1
				#player_instance = Player.new("John", "Doe", "2000-01-01", "Football", "Forward")
	file.close()
	#print(allPlayer)
	print(all_clubs)
	return all_clubs
