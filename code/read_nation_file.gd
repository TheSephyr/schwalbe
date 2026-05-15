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
	var newManager: Manager
	var newTrainer: Trainer
	var stadionLines: Array[String] = []

	while !file.eof_reached():
		var line = file.get_line()
		if(line.begins_with("%")):
			match(line):
				PLAYER_MARKER_START:
					readingPlayer = true
					newPlayer = Player.new()
				PLAYER_MARKER_END:
					newPlayer.generate_contract()
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
					newTrainer = Trainer.new("", "", "")
					lineCounterCoach = 1
				COACH_MARKER_END:
					readingCoach = false
					if newClub != null:
						newClub.trainer = newTrainer
				MANAGER_MARKER_START:
					readingManager = true
					newManager = Manager.new("", "", "")
					lineCounterManager = 1
				MANAGER_MARKER_END:
					readingManager = false
					if newClub != null:
						newClub.manager = newManager
				STADION_MARKER_START:
					readingStadion = true
					stadionLines = []
				STADION_MARKER_END:
					readingStadion = false
					if newClub != null:
						newClub.stadium = _parse_stadion(stadionLines)
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
			if readingCoach:
				match lineCounterCoach:
					1: newTrainer.lastname = line
					2: newTrainer.firstname = line
					6: newTrainer.birthdate = line
				lineCounterCoach += 1
			if readingManager:
				match lineCounterManager:
					1: newManager.lastname = line
					2: newManager.firstname = line
					5: newManager.birthdate = line
				lineCounterManager += 1
			if readingStadion:
				stadionLines.append(line)
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


static func _parse_stadion(lines: Array[String]) -> Stadium:
	var s := Stadium.new()
	if lines.size() < 2:
		return s
	s.name = lines[0]
	s.city = lines[1]

	# Capacity data starts at index 13 if that line is already a large number,
	# otherwise at index 14 (the 0-padding line means data is one step later).
	var cap_idx: int = 14
	if lines.size() > 13 and lines[13].to_int() > 100:
		cap_idx = 13

	var type_flag: int = _stadion_val(lines, cap_idx + 2)

	if type_flag >= 4:
		# Compact format: W and E capacities are stored in the "aux" field of
		# the preceding block rather than as the first value of their own block.
		s.north = _stadion_val(lines, cap_idx) + _stadion_val(lines, cap_idx + 1)
		s.south = _stadion_val(lines, cap_idx + 4) + _stadion_val(lines, cap_idx + 5)
		s.west = _stadion_val(lines, cap_idx + 7)
		s.east = _stadion_val(lines, cap_idx + 11)
	else:
		# Standard format: each block is seating + standing at stride-4 offsets.
		s.north = _stadion_val(lines, cap_idx) + _stadion_val(lines, cap_idx + 1)
		s.south = _stadion_val(lines, cap_idx + 4) + _stadion_val(lines, cap_idx + 5)
		s.west = _stadion_val(lines, cap_idx + 8) + _stadion_val(lines, cap_idx + 9)
		s.east = _stadion_val(lines, cap_idx + 12) + _stadion_val(lines, cap_idx + 13)

	return s


static func _stadion_val(lines: Array[String], i: int) -> int:
	return lines[i].to_int() if i < lines.size() else 0
