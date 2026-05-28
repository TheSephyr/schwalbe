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

const REPORTER_MARKER_START: String = "%SECT%REPORTER"
const REPORTER_MARKER_END: String = "%ENDSECT%REPORTER"

const REFEREE_MARKER_START: String = "%SECT%SCHIRI"
const REFEREE_MARKER_END: String = "%ENDSECT%SCHIRI"

const INT_REFEREE_MARKER_START: String = "%SECT%ISCHIRI"
const INT_REFEREE_MARKER_END: String = "%ENDSECT%ISCHIRI"

const CELEBRITY_MARKER_START: String = "%SECT%PROMI"
const CELEBRITY_MARKER_END: String = "%ENDSECT%PROMI"

const SPONSOR_MARKER_START: String = "%SECT%SPONSOR"
const SPONSOR_MARKER_END: String = "%ENDSECT%SPONSOR"


static func loadNationFile(nationFile: String) -> Dictionary:
	var allPlayer: Array[Player]
	var all_clubs: Array[Club]
	var all_reporters: Array[Reporter] = []
	var all_referees: Array[Referee] = []
	var all_celebrities: Array[Celebrity] = []
	var all_sponsors: Array[Sponsor] = []
	var file = FileAccess.open(nationFile, FileAccess.READ)
	var fileContent = file.get_as_text()
	var readingPlayer: bool = false
	var readingClub: bool = false
	var readingClubPost: bool = false
	var readingCoach: bool = false
	var readingManager: bool = false
	var readingStadion: bool = false
	var readingReporter: bool = false
	var readingReferee: bool = false
	var readingCelebrity: bool = false
	var readingSponsor: bool = false
	var lineCounterPlayer: int = 0
	var lineCounterClub: int = 0
	var lineCounterClubPost: int = 0
	var lineCounterCoach: int = 0
	var lineCounterManager: int = 0
	var lineCounterReporter: int = 0
	var lineCounterReferee: int = 0
	var lineCounterCelebrity: int = 0
	var lineCounterSponsor: int = 0
	var newPlayer: Player
	var newClub: Club
	var newManager: Manager
	var newTrainer: Trainer
	var newReporter: Reporter
	var newReferee: Referee
	var newCelebrity: Celebrity
	var newSponsor: Sponsor
	var stadionLines: Array[String] = []

	while !file.eof_reached():
		var line = file.get_line()
		if line.begins_with("%"):
			match line:
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
					readingClubPost = false
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
					if readingClub:
						readingClubPost = true
						lineCounterClubPost = 0
				REPORTER_MARKER_START:
					readingReporter = true
					newReporter = Reporter.new()
					lineCounterReporter = 0
				REPORTER_MARKER_END:
					readingReporter = false
					all_reporters.append(newReporter)
				REFEREE_MARKER_START:
					readingReferee = true
					newReferee = Referee.new()
					lineCounterReferee = 0
				REFEREE_MARKER_END:
					readingReferee = false
					all_referees.append(newReferee)
				INT_REFEREE_MARKER_START:
					readingReferee = true
					newReferee = Referee.new()
					lineCounterReferee = 0
				INT_REFEREE_MARKER_END:
					readingReferee = false
					all_referees.append(newReferee)
				CELEBRITY_MARKER_START:
					readingCelebrity = true
					newCelebrity = Celebrity.new()
					lineCounterCelebrity = 0
				CELEBRITY_MARKER_END:
					readingCelebrity = false
					all_celebrities.append(newCelebrity)
				SPONSOR_MARKER_START:
					readingSponsor = true
					newSponsor = Sponsor.new()
					lineCounterSponsor = 0
				SPONSOR_MARKER_END:
					readingSponsor = false
					all_sponsors.append(newSponsor)
		else:
			if readingClub:
				match lineCounterClub:
					ClubFieldIndex.HeaderField.COUNTRY:
						newClub.nation = line
					ClubFieldIndex.HeaderField.CLUB_NAME:
						newClub.name = line
					ClubFieldIndex.HeaderField.ABBREVIATION:
						newClub.abbreviation = line
					ClubFieldIndex.HeaderField.CHANT:
						newClub.chant = line
					ClubFieldIndex.HeaderField.FAN_NAME:
						newClub.fan_name = line
				lineCounterClub += 1

			if readingClubPost:
				var val := line.to_int()
				match lineCounterClubPost:
					ClubFieldIndex.PostField.HOME_KIT_COLOR1_PATTERN:
						newClub.home_kit_color1 = (val & 0xF) as KitColorTypes.KitColor
						newClub.home_kit_pattern = ((val >> 4) & 0xF) as KitPatternTypes.KitPattern
					ClubFieldIndex.PostField.HOME_KIT_COLOR2:
						newClub.home_kit_color2 = val as KitColorTypes.KitColor
					ClubFieldIndex.PostField.HOME_KIT_SHORTS_COLOR:
						newClub.home_kit_shorts_color = val as KitColorTypes.KitColor
					ClubFieldIndex.PostField.HOME_KIT_SOCKS:
						newClub.home_kit_socks_color = (val & 0xF) as KitColorTypes.KitColor
						newClub.home_kit_socks_striped = (val & 0x10) != 0
					ClubFieldIndex.PostField.AWAY_KIT_COLOR1_PATTERN:
						newClub.away_kit_color1 = (val & 0xF) as KitColorTypes.KitColor
						newClub.away_kit_pattern = ((val >> 4) & 0xF) as KitPatternTypes.KitPattern
					ClubFieldIndex.PostField.AWAY_KIT_COLOR2:
						newClub.away_kit_color2 = val as KitColorTypes.KitColor
					ClubFieldIndex.PostField.AWAY_KIT_SHORTS_COLOR:
						newClub.away_kit_shorts_color = val as KitColorTypes.KitColor
					ClubFieldIndex.PostField.AWAY_KIT_SOCKS:
						newClub.away_kit_socks_color = (val & 0xF) as KitColorTypes.KitColor
						newClub.away_kit_socks_striped = (val & 0x10) != 0
					ClubFieldIndex.PostField.BALANCE:
						newClub.money = val
					ClubFieldIndex.PostField.ABBREVIATION_ARTICLE:
						newClub.abbreviation_article = val as AbbreviationArticleTypes.Article
					ClubFieldIndex.PostField.FAN_ATTENDANCE:
						newClub.fan_attendance = val as FanAttendanceTypes.FanAttendance
					ClubFieldIndex.PostField.FAN_TYPE:
						newClub.fan_type = val as FanTypeTypes.FanType
					ClubFieldIndex.PostField.FAN_FRIENDSHIP_WITH:
						newClub.fan_friendship_with = val
					ClubFieldIndex.PostField.ARCH_RIVAL:
						newClub.arch_rival = val
					ClubFieldIndex.PostField.BOARD:
						newClub.board = val as BoardTypes.Board
					ClubFieldIndex.PostField.CUP_TEAM:
						newClub.cup_team = val
					ClubFieldIndex.PostField.OPPOSITION:
						newClub.opposition = val as OppositionTypes.Opposition
					ClubFieldIndex.PostField.AMATEUR_SECTION_OF:
						newClub.amateur_section_of = val
					ClubFieldIndex.PostField.PRO_SECTION_OF:
						newClub.pro_section_of = val
					ClubFieldIndex.PostField.FINANCIAL_STRENGTH:
						newClub.financial_strength = val as FinancialStrengthTypes.FinancialStrength
					ClubFieldIndex.PostField.MAX_FAN_ATTENDANCE:
						newClub.max_fan_attendance = val
					ClubFieldIndex.PostField.HOOLIGANS:
						newClub.hooligans = val as HooliganTypes.Hooligans
					ClubFieldIndex.PostField.MEDIA_CITY:
						newClub.media_city = line
					ClubFieldIndex.PostField.ALL_TIME_GOALS:
						newClub.all_time_goals = val
					ClubFieldIndex.PostField.ALL_TIME_GOALS_AGAINST:
						newClub.all_time_goals_against = val
					ClubFieldIndex.PostField.ALL_TIME_MATCHES:
						newClub.all_time_matches = val
					ClubFieldIndex.PostField.ALL_TIME_POINTS:
						newClub.all_time_points = val
					ClubFieldIndex.PostField.CHAIRMAN_LAST_NAME:
						newClub.chairman_lastname = line
					ClubFieldIndex.PostField.CHAIRMAN_FIRST_NAME:
						newClub.chairman_firstname = line
					ClubFieldIndex.PostField.CHAIRMAN_BIRTHDAY:
						newClub.chairman_birthday = line
					ClubFieldIndex.PostField.PUBLIC_COMPANY:
						newClub.public_company = val != 0
					ClubFieldIndex.PostField.TITLES_CHAMPIONSHIPS:
						newClub.titles_championships = val
					ClubFieldIndex.PostField.TITLES_CUPS:
						newClub.titles_cups = val
					ClubFieldIndex.PostField.TITLES_LEAGUE_CUPS:
						newClub.titles_league_cups = val
					ClubFieldIndex.PostField.TITLES_EUROPA_LEAGUES:
						newClub.titles_europa_leagues = val
					ClubFieldIndex.PostField.TITLES_CHAMPIONS_LEAGUES:
						newClub.titles_champions_leagues = val
					ClubFieldIndex.PostField.TITLES_WORLD_CUPS:
						newClub.titles_world_cups = val
					ClubFieldIndex.PostField.REGIONAL_LEAGUE_FROM_2000:
						newClub.regional_league = val as RegionalLeagueTypes.RegionalLeague
					ClubFieldIndex.PostField.FOUNDING_YEAR:
						newClub.founding_year = val
				lineCounterClubPost += 1

			if readingCoach:
				match lineCounterCoach:
					TrainerFieldIndex.Field.FIRST_NAME:  newTrainer.firstname = line
					TrainerFieldIndex.Field.LAST_NAME:   newTrainer.lastname = line
					TrainerFieldIndex.Field.COMPETENCE:  newTrainer.competence = line.to_int()
					TrainerFieldIndex.Field.REPUTATION:  newTrainer.reputation = line.to_int() as TrainerReputationTypes.Reputation
					TrainerFieldIndex.Field.BIRTHDAY:    newTrainer.birthdate = line
				lineCounterCoach += 1

			if readingManager:
				match lineCounterManager:
					ManagerFieldIndex.Field.FIRST_NAME:  newManager.firstname = line
					ManagerFieldIndex.Field.LAST_NAME:   newManager.lastname = line
					ManagerFieldIndex.Field.COMPETENCE:  newManager.competence = line.to_int()
					ManagerFieldIndex.Field.BIRTHDAY:    newManager.birthdate = line
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
						if newPlayer.position == "1":
							for skill_val: int in GoalkeeperSkillTypes.Skill.values():
								if mask & skill_val:
									newPlayer.gk_positive_skills.append(skill_val as GoalkeeperSkillTypes.Skill)
						else:
							for skill_val: int in PlayerSkillTypes.Skill.values():
								if mask & skill_val:
									newPlayer.positive_skills.append(skill_val as PlayerSkillTypes.Skill)
					PlayerFieldIndex.Field.NEGATIVE_SKILLS:
						var mask := line.to_int()
						if newPlayer.position == "1":
							for skill_val: int in GoalkeeperSkillTypes.Skill.values():
								if mask & skill_val:
									newPlayer.gk_negative_skills.append(skill_val as GoalkeeperSkillTypes.Skill)
						else:
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

			if readingReporter:
				match lineCounterReporter:
					ReporterFieldIndex.Field.BROADCASTER: newReporter.broadcaster = line
					ReporterFieldIndex.Field.LAST_NAME:   newReporter.lastname = line
					ReporterFieldIndex.Field.FIRST_NAME:  newReporter.firstname = line
					ReporterFieldIndex.Field.ATTITUDE:    newReporter.attitude = line.to_int() as ReporterAttitudeTypes.Attitude
				lineCounterReporter += 1

			if readingReferee:
				match lineCounterReferee:
					RefereeFieldIndex.Field.FIRST_NAME:
						newReferee.firstname = line
					RefereeFieldIndex.Field.LAST_NAME:
						newReferee.lastname = line
					RefereeFieldIndex.Field.COMPETENCE:
						newReferee.competence = line.to_int()
					RefereeFieldIndex.Field.STRICTNESS:
						newReferee.strictness = line.to_int()
					RefereeFieldIndex.Field.DISLIKED_CLUB:
						newReferee.disliked_club = line.to_int()
					RefereeFieldIndex.Field.CHARACTERISTICS:
						var mask := line.to_int()
						for char_val: int in RefereeCharacteristicTypes.Characteristic.values():
							if mask & char_val:
								newReferee.characteristics.append(char_val as RefereeCharacteristicTypes.Characteristic)
				lineCounterReferee += 1

			if readingCelebrity:
				match lineCounterCelebrity:
					CelebrityFieldIndex.Field.LAST_NAME:      newCelebrity.lastname = line
					CelebrityFieldIndex.Field.FIRST_NAME:     newCelebrity.firstname = line
					CelebrityFieldIndex.Field.FAVORITE_CLUB:  newCelebrity.favorite_club = line.to_int()
				lineCounterCelebrity += 1

			if readingSponsor:
				match lineCounterSponsor:
					SponsorFieldIndex.Field.NAME:    newSponsor.name = line
					SponsorFieldIndex.Field.INCOME:  newSponsor.income_per_season = line.to_int() * 1000
				lineCounterSponsor += 1

	file.close()
	print(all_clubs)
	return {
		"clubs": all_clubs,
		"reporters": all_reporters,
		"referees": all_referees,
		"celebrities": all_celebrities,
		"sponsors": all_sponsors,
	}


static func _parse_stadion(lines: Array[String]) -> Stadium:
	var s := Stadium.new()
	s.name = _sval(lines, StadiumFieldIndex.Field.NAME)
	s.city = _sval(lines, StadiumFieldIndex.Field.CITY)
	s.scoreboard = _ival(lines, StadiumFieldIndex.Field.SCOREBOARD) as ScoreboardTypes.Scoreboard
	s.pitch_heating = _ival(lines, StadiumFieldIndex.Field.PITCH_HEATING) != 0
	s.floodlights = _ival(lines, StadiumFieldIndex.Field.FLOODLIGHTS) != 0
	s.home_stand = _ival(lines, StadiumFieldIndex.Field.HOME_STAND)
	s.away_stand = _ival(lines, StadiumFieldIndex.Field.AWAY_STAND)
	s.city_location = _ival(lines, StadiumFieldIndex.Field.CITY_LOCATION)
	s.owned = _ival(lines, StadiumFieldIndex.Field.OWNED) != 0
	s.motorway = _ival(lines, StadiumFieldIndex.Field.MOTORWAY) != 0
	s.tv_tower = _ival(lines, StadiumFieldIndex.Field.TV_TOWER) != 0
	s.north = _ival(lines, StadiumFieldIndex.Field.MAIN_STANDING) + _ival(lines, StadiumFieldIndex.Field.MAIN_SEATING)
	s.main_vip = _ival(lines, StadiumFieldIndex.Field.MAIN_VIP)
	s.main_condition = _ival(lines, StadiumFieldIndex.Field.MAIN_CONDITION) as StadiumConditionTypes.Condition
	s.south = _ival(lines, StadiumFieldIndex.Field.AWAY_STANDING) + _ival(lines, StadiumFieldIndex.Field.AWAY_SEATING)
	s.away_vip = _ival(lines, StadiumFieldIndex.Field.AWAY_VIP)
	s.away_condition = _ival(lines, StadiumFieldIndex.Field.AWAY_CONDITION) as StadiumConditionTypes.Condition
	s.west = _ival(lines, StadiumFieldIndex.Field.LEFT_STANDING) + _ival(lines, StadiumFieldIndex.Field.LEFT_SEATING)
	s.left_vip = _ival(lines, StadiumFieldIndex.Field.LEFT_VIP)
	s.left_condition = _ival(lines, StadiumFieldIndex.Field.LEFT_CONDITION) as StadiumConditionTypes.Condition
	s.east = _ival(lines, StadiumFieldIndex.Field.RIGHT_STANDING) + _ival(lines, StadiumFieldIndex.Field.RIGHT_SEATING)
	s.right_vip = _ival(lines, StadiumFieldIndex.Field.RIGHT_VIP)
	s.right_condition = _ival(lines, StadiumFieldIndex.Field.RIGHT_CONDITION) as StadiumConditionTypes.Condition
	s.roof = _ival(lines, StadiumFieldIndex.Field.ROOF)
	s.running_track = _ival(lines, StadiumFieldIndex.Field.RUNNING_TRACK) != 0
	s.heat_lamps = _ival(lines, StadiumFieldIndex.Field.HEAT_LAMPS)
	s.luxury_boxes = _ival(lines, StadiumFieldIndex.Field.LUXURY_BOXES)
	s.seat_cushions = _ival(lines, StadiumFieldIndex.Field.SEAT_CUSHIONS) != 0
	s.heated_seats = _ival(lines, StadiumFieldIndex.Field.HEATED_SEATS) != 0
	s.retractable_pitch = _ival(lines, StadiumFieldIndex.Field.RETRACTABLE_PITCH) != 0
	s.mountains = _ival(lines, StadiumFieldIndex.Field.MOUNTAINS) != 0
	s.castle = _ival(lines, StadiumFieldIndex.Field.CASTLE) != 0
	s.palace = _ival(lines, StadiumFieldIndex.Field.PALACE) != 0
	return s


static func _sval(lines: Array[String], i: int) -> String:
	return lines[i] if i < lines.size() else ""


static func _ival(lines: Array[String], i: int) -> int:
	return lines[i].to_int() if i < lines.size() else 0
