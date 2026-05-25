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
	var lineCounterPlayer: int = 0
	var lineCounterClub: int = 0
	var lineCounterCoach: int = 0
	var lineCounterManager: int = 0
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
					lineCounterPlayer = 0
					readingPlayer = false
				CLUB_MARKER_START:
					readingClub = true
					newClub = Club.new()
					allPlayer = []
				CLUB_MARKER_END:
					readingClub = false
					newClub.players = allPlayer
					lineCounterClub = 0
					all_clubs.append(newClub)
				COACH_MARKER_START:
					readingCoach = true
					newTrainer = Trainer.new("", "", "")
					lineCounterCoach = 0
				COACH_MARKER_END:
					readingCoach = false
					if newClub != null:
						newClub.trainer = newTrainer
				MANAGER_MARKER_START:
					readingManager = true
					newManager = Manager.new("", "", "")
					lineCounterManager = 0
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
				match lineCounterClub:
					ClubFieldIndex.HeaderField.COUNTRY:
						newClub.nation = line
					ClubFieldIndex.HeaderField.CLUB_NAME:
						newClub.name = line
				lineCounterClub += 1
			if readingCoach:
				match lineCounterCoach:
					TrainerFieldIndex.Field.FIRST_NAME: newTrainer.firstname = line
					TrainerFieldIndex.Field.LAST_NAME:  newTrainer.lastname = line
					TrainerFieldIndex.Field.BIRTHDAY:   newTrainer.birthdate = line
				lineCounterCoach += 1
			if readingManager:
				match lineCounterManager:
					ManagerFieldIndex.Field.FIRST_NAME: newManager.firstname = line
					ManagerFieldIndex.Field.LAST_NAME:  newManager.lastname = line
					ManagerFieldIndex.Field.BIRTHDAY:   newManager.birthdate = line
				lineCounterManager += 1
			if readingStadion:
				stadionLines.append(line)
			if readingPlayer:
				match lineCounterPlayer:
					PlayerFieldIndex.Field.LAST_NAME:
						newPlayer.lastname = line
					PlayerFieldIndex.Field.FIRST_NAME:
						newPlayer.firstname = line
					PlayerFieldIndex.Field.SKIN_COLOR:
						newPlayer.skin_color = line.to_int() as SkinColorTypes.SkinColor
					PlayerFieldIndex.Field.HAIR_COLOR:
						newPlayer.hair_color = line.to_int() as HairColorTypes.HairColor
					PlayerFieldIndex.Field.ABILITY:
						newPlayer.currentAbility = line
					PlayerFieldIndex.Field.COUNTRY:
						newPlayer.country = line.to_int()
					PlayerFieldIndex.Field.MAIN_POSITION:
						newPlayer.position = line
					PlayerFieldIndex.Field.SECONDARY_POSITION_1:
						newPlayer.secondary_position_1 = line.to_int() as PositionTypes.Position
					PlayerFieldIndex.Field.SECONDARY_POSITION_2:
						newPlayer.secondary_position_2 = line.to_int() as PositionTypes.Position
					PlayerFieldIndex.Field.POSITIVE_SKILLS:
						var mask := line.to_int()
						for skill_val: int in PlayerSkillTypes.Skill.values():
							if mask & skill_val:
								newPlayer.positive_skills.append(skill_val as PlayerSkillTypes.Skill)
					PlayerFieldIndex.Field.NEGATIVE_SKILLS:
						var mask := line.to_int()
						for skill_val: int in PlayerSkillTypes.Skill.values():
							if mask & skill_val:
								newPlayer.negative_skills.append(skill_val as PlayerSkillTypes.Skill)
					PlayerFieldIndex.Field.CHARACTERISTICS:
						var mask := line.to_int()
						for char_val: int in PlayerCharacteristicTypes.Characteristic.values():
							if mask & char_val:
								newPlayer.characteristics.append(char_val as PlayerCharacteristicTypes.Characteristic)
					PlayerFieldIndex.Field.CHARACTER:
						newPlayer.character = line.to_int() as PlayerCharacterTypes.Character
					PlayerFieldIndex.Field.HAS_STAGE_NAME:
						newPlayer.has_stage_name = line.to_int() != 0
					PlayerFieldIndex.Field.STAGE_NAME:
						newPlayer.stage_name = line
					PlayerFieldIndex.Field.FOOT:
						newPlayer.foot = line.to_int() as FootTypes.Foot
					PlayerFieldIndex.Field.TALENT:
						newPlayer.talent = line
					PlayerFieldIndex.Field.HEALTH:
						newPlayer.health = line.to_int() as HealthTypes.Health
					PlayerFieldIndex.Field.CROWD_APPEAL:
						newPlayer.crowd_appeal = line.to_int() as CrowdAppealTypes.CrowdAppeal
					PlayerFieldIndex.Field.BIRTHDAY:
						newPlayer.birthdate = line
					PlayerFieldIndex.Field.COUNTRY_2:
						newPlayer.country_2 = line.to_int()
					PlayerFieldIndex.Field.NATIONAL_PLAYER:
						newPlayer.nation_player = line.to_int()
					PlayerFieldIndex.Field.CAPTAIN_RETIREMENT:
						newPlayer.captain_retirement = line.to_int()
					PlayerFieldIndex.Field.SQUAD_NUMBER:
						newPlayer.squad_number = line.to_int()
					PlayerFieldIndex.Field.HAIR_BEARD:
						var val := line.to_int()
						newPlayer.hair_style = (val >> 16) as HairStyleTypes.HairStyle
						newPlayer.beard = (val & 0xF) as BeardTypes.Beard
				lineCounterPlayer += 1
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
