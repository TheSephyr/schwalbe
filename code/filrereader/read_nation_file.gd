class_name ReadNationFile

enum Section {
	NONE,
	PLAYER,
	CLUB_HEADER,
	CLUB_COACH,
	CLUB_MANAGER,
	CLUB_STADION,
	CLUB_POST,
	REPORTER,
	REFEREE,
	CELEBRITY,
	SPONSOR,
}

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
	var _content := EncodingHelper.read_file(nationFile)
	var _lines := _content.replace("\r\n", "\n").replace("\r", "\n").split("\n")
	var _line_index: int = 0
	var section: Section = Section.NONE
	var line_counter: int = 0
	var newPlayer: Player
	var newClub: Club
	var newManager: Manager
	var newTrainer: Trainer
	var newReporter: Reporter
	var newReferee: Referee
	var newCelebrity: Celebrity
	var newSponsor: Sponsor
	var stadionLines: Array[String] = []

	while _line_index < _lines.size():
		var line := _lines[_line_index]
		_line_index += 1
		if line.begins_with("%"):
			match line:
				PLAYER_MARKER_START:
					section = Section.PLAYER
					line_counter = 0
					newPlayer = Player.new()
				PLAYER_MARKER_END:
					newPlayer.generate_contract()
					allPlayer.append(newPlayer)
					section = Section.NONE
				CLUB_MARKER_START:
					section = Section.CLUB_HEADER
					line_counter = 0
					newClub = Club.new()
					allPlayer = []
				CLUB_MARKER_END:
					newClub.players = allPlayer
					all_clubs.append(newClub)
					section = Section.NONE
				COACH_MARKER_START:
					section = Section.CLUB_COACH
					line_counter = 0
					newTrainer = Trainer.new("", "", "")
				COACH_MARKER_END:
					if newClub != null:
						newClub.trainer = newTrainer
					section = Section.CLUB_HEADER
				MANAGER_MARKER_START:
					section = Section.CLUB_MANAGER
					line_counter = 0
					newManager = Manager.new("", "", "")
				MANAGER_MARKER_END:
					if newClub != null:
						newClub.manager = newManager
					section = Section.CLUB_HEADER
				STADION_MARKER_START:
					section = Section.CLUB_STADION
					stadionLines = []
				STADION_MARKER_END:
					if newClub != null:
						newClub.stadium = _parse_stadion(stadionLines)
					section = Section.CLUB_POST
					line_counter = 0
				REPORTER_MARKER_START:
					section = Section.REPORTER
					line_counter = 0
					newReporter = Reporter.new()
				REPORTER_MARKER_END:
					all_reporters.append(newReporter)
					section = Section.NONE
				REFEREE_MARKER_START, INT_REFEREE_MARKER_START:
					section = Section.REFEREE
					line_counter = 0
					newReferee = Referee.new()
				REFEREE_MARKER_END, INT_REFEREE_MARKER_END:
					all_referees.append(newReferee)
					section = Section.NONE
				CELEBRITY_MARKER_START:
					section = Section.CELEBRITY
					line_counter = 0
					newCelebrity = Celebrity.new()
				CELEBRITY_MARKER_END:
					all_celebrities.append(newCelebrity)
					section = Section.NONE
				SPONSOR_MARKER_START:
					section = Section.SPONSOR
					line_counter = 0
					newSponsor = Sponsor.new()
				SPONSOR_MARKER_END:
					all_sponsors.append(newSponsor)
					section = Section.NONE
		else:
			match section:
				Section.PLAYER:
					_read_player_line(newPlayer, line, line_counter)
				Section.CLUB_HEADER:
					_read_club_header_line(newClub, line, line_counter)
				Section.CLUB_COACH:
					_read_coach_line(newTrainer, line, line_counter)
				Section.CLUB_MANAGER:
					_read_manager_line(newManager, line, line_counter)
				Section.CLUB_STADION:
					stadionLines.append(line)
				Section.CLUB_POST:
					_read_club_post_line(newClub, line, line_counter)
				Section.REPORTER:
					_read_reporter_line(newReporter, line, line_counter)
				Section.REFEREE:
					_read_referee_line(newReferee, line, line_counter)
				Section.CELEBRITY:
					_read_celebrity_line(newCelebrity, line, line_counter)
				Section.SPONSOR:
					_read_sponsor_line(newSponsor, line, line_counter)
			line_counter += 1


	return {
		"clubs": all_clubs,
		"reporters": all_reporters,
		"referees": all_referees,
		"celebrities": all_celebrities,
		"sponsors": all_sponsors,
	}


static func _read_player_line(player: Player, line: String, i: int) -> void:
	match i:
		PlayerFieldIndex.Field.LAST_NAME:
			player.lastname = line
		PlayerFieldIndex.Field.FIRST_NAME:
			player.firstname = line
		PlayerFieldIndex.Field.SKIN_COLOR:
			player.skin_color = line.to_int() as SkinColorTypes.SkinColor
		PlayerFieldIndex.Field.HAIR_COLOR:
			player.hair_color = line.to_int() as HairColorTypes.HairColor
		PlayerFieldIndex.Field.ABILITY:
			player.currentAbility = line
		PlayerFieldIndex.Field.COUNTRY:
			player.country = line.to_int()
		PlayerFieldIndex.Field.MAIN_POSITION:
			player.position = line
		PlayerFieldIndex.Field.SECONDARY_POSITION_1:
			player.secondary_position_1 = line.to_int() as PositionTypes.Position
		PlayerFieldIndex.Field.SECONDARY_POSITION_2:
			player.secondary_position_2 = line.to_int() as PositionTypes.Position
		PlayerFieldIndex.Field.POSITIVE_SKILLS:
			var mask := line.to_int()
			if player.position == "1":
				for skill_val: int in GoalkeeperSkillTypes.Skill.values():
					if mask & skill_val:
						player.gk_positive_skills.append(skill_val as GoalkeeperSkillTypes.Skill)
			else:
				for skill_val: int in PlayerSkillTypes.Skill.values():
					if mask & skill_val:
						player.positive_skills.append(skill_val as PlayerSkillTypes.Skill)
		PlayerFieldIndex.Field.NEGATIVE_SKILLS:
			var mask := line.to_int()
			if player.position == "1":
				for skill_val: int in GoalkeeperSkillTypes.Skill.values():
					if mask & skill_val:
						player.gk_negative_skills.append(skill_val as GoalkeeperSkillTypes.Skill)
			else:
				for skill_val: int in PlayerSkillTypes.Skill.values():
					if mask & skill_val:
						player.negative_skills.append(skill_val as PlayerSkillTypes.Skill)
		PlayerFieldIndex.Field.CHARACTERISTICS:
			var mask := line.to_int()
			for char_val: int in PlayerCharacteristicTypes.Characteristic.values():
				if mask & char_val:
					player.characteristics.append(char_val as PlayerCharacteristicTypes.Characteristic)
		PlayerFieldIndex.Field.CHARACTER:
			player.character = line.to_int() as PlayerCharacterTypes.Character
		PlayerFieldIndex.Field.HAS_STAGE_NAME:
			player.has_stage_name = line.to_int() != 0
		PlayerFieldIndex.Field.STAGE_NAME:
			player.stage_name = line
		PlayerFieldIndex.Field.FOOT:
			player.foot = line.to_int() as FootTypes.Foot
		PlayerFieldIndex.Field.TALENT:
			player.talent = line
		PlayerFieldIndex.Field.HEALTH:
			player.health = line.to_int() as HealthTypes.Health
		PlayerFieldIndex.Field.CROWD_APPEAL:
			player.crowd_appeal = line.to_int() as CrowdAppealTypes.CrowdAppeal
		PlayerFieldIndex.Field.BIRTHDAY:
			player.birthdate = line
		PlayerFieldIndex.Field.COUNTRY_2:
			player.country_2 = line.to_int()
		PlayerFieldIndex.Field.NATIONAL_PLAYER:
			player.nation_player = line.to_int()
		PlayerFieldIndex.Field.CAPTAIN_RETIREMENT:
			player.captain_retirement = line.to_int()
		PlayerFieldIndex.Field.SQUAD_NUMBER:
			player.squad_number = line.to_int()
		PlayerFieldIndex.Field.HAIR_BEARD:
			var val := line.to_int()
			player.hair_style = (val >> 16) as HairStyleTypes.HairStyle
			player.beard = (val & 0xF) as BeardTypes.Beard


static func _read_club_header_line(club: Club, line: String, i: int) -> void:
	match i:
		ClubFieldIndex.HeaderField.COUNTRY:      club.nation = line
		ClubFieldIndex.HeaderField.CLUB_NAME:    club.name = line
		ClubFieldIndex.HeaderField.ABBREVIATION: club.abbreviation = line
		ClubFieldIndex.HeaderField.CHANT:        club.chant = line
		ClubFieldIndex.HeaderField.FAN_NAME:     club.fan_name = line


static func _read_club_post_line(club: Club, line: String, i: int) -> void:
	var val := line.to_int()
	match i:
		ClubFieldIndex.PostField.HOME_KIT_COLOR1_PATTERN:
			club.home_kit_color1 = (val & 0xF) as KitColorTypes.KitColor
			club.home_kit_pattern = ((val >> 4) & 0xF) as KitPatternTypes.KitPattern
		ClubFieldIndex.PostField.HOME_KIT_COLOR2:
			club.home_kit_color2 = val as KitColorTypes.KitColor
		ClubFieldIndex.PostField.HOME_KIT_SHORTS_COLOR:
			club.home_kit_shorts_color = val as KitColorTypes.KitColor
		ClubFieldIndex.PostField.HOME_KIT_SOCKS:
			club.home_kit_socks_color = (val & 0xF) as KitColorTypes.KitColor
			club.home_kit_socks_striped = (val & 0x10) != 0
		ClubFieldIndex.PostField.AWAY_KIT_COLOR1_PATTERN:
			club.away_kit_color1 = (val & 0xF) as KitColorTypes.KitColor
			club.away_kit_pattern = ((val >> 4) & 0xF) as KitPatternTypes.KitPattern
		ClubFieldIndex.PostField.AWAY_KIT_COLOR2:
			club.away_kit_color2 = val as KitColorTypes.KitColor
		ClubFieldIndex.PostField.AWAY_KIT_SHORTS_COLOR:
			club.away_kit_shorts_color = val as KitColorTypes.KitColor
		ClubFieldIndex.PostField.AWAY_KIT_SOCKS:
			club.away_kit_socks_color = (val & 0xF) as KitColorTypes.KitColor
			club.away_kit_socks_striped = (val & 0x10) != 0
		ClubFieldIndex.PostField.BALANCE:
			club.money = val
		ClubFieldIndex.PostField.ABBREVIATION_ARTICLE:
			club.abbreviation_article = val as AbbreviationArticleTypes.Article
		ClubFieldIndex.PostField.FAN_ATTENDANCE:
			club.fan_attendance = val as FanAttendanceTypes.FanAttendance
		ClubFieldIndex.PostField.FAN_TYPE:
			club.fan_type = val as FanTypeTypes.FanType
		ClubFieldIndex.PostField.FAN_FRIENDSHIP_WITH:
			club.fan_friendship_with = val
		ClubFieldIndex.PostField.ARCH_RIVAL:
			club.arch_rival = val
		ClubFieldIndex.PostField.BOARD:
			club.board = val as BoardTypes.Board
		ClubFieldIndex.PostField.CUP_TEAM:
			club.cup_team = val
		ClubFieldIndex.PostField.OPPOSITION:
			club.opposition = val as OppositionTypes.Opposition
		ClubFieldIndex.PostField.AMATEUR_SECTION_OF:
			club.amateur_section_of = val
		ClubFieldIndex.PostField.PRO_SECTION_OF:
			club.pro_section_of = val
		ClubFieldIndex.PostField.FINANCIAL_STRENGTH:
			club.financial_strength = val as FinancialStrengthTypes.FinancialStrength
		ClubFieldIndex.PostField.MAX_FAN_ATTENDANCE:
			club.max_fan_attendance = val
		ClubFieldIndex.PostField.HOOLIGANS:
			club.hooligans = val as HooliganTypes.Hooligans
		ClubFieldIndex.PostField.MEDIA_CITY:
			club.media_city = line
		ClubFieldIndex.PostField.ALL_TIME_GOALS:
			club.all_time_goals = val
		ClubFieldIndex.PostField.ALL_TIME_GOALS_AGAINST:
			club.all_time_goals_against = val
		ClubFieldIndex.PostField.ALL_TIME_MATCHES:
			club.all_time_matches = val
		ClubFieldIndex.PostField.ALL_TIME_POINTS:
			club.all_time_points = val
		ClubFieldIndex.PostField.CHAIRMAN_LAST_NAME:
			club.chairman_lastname = line
		ClubFieldIndex.PostField.CHAIRMAN_FIRST_NAME:
			club.chairman_firstname = line
		ClubFieldIndex.PostField.CHAIRMAN_BIRTHDAY:
			club.chairman_birthday = line
		ClubFieldIndex.PostField.PUBLIC_COMPANY:
			club.public_company = val != 0
		ClubFieldIndex.PostField.TITLES_CHAMPIONSHIPS:
			club.titles_championships = val
		ClubFieldIndex.PostField.TITLES_CUPS:
			club.titles_cups = val
		ClubFieldIndex.PostField.TITLES_LEAGUE_CUPS:
			club.titles_league_cups = val
		ClubFieldIndex.PostField.TITLES_EUROPA_LEAGUES:
			club.titles_europa_leagues = val
		ClubFieldIndex.PostField.TITLES_CHAMPIONS_LEAGUES:
			club.titles_champions_leagues = val
		ClubFieldIndex.PostField.TITLES_WORLD_CUPS:
			club.titles_world_cups = val
		ClubFieldIndex.PostField.REGIONAL_LEAGUE_FROM_2000:
			club.regional_league = val as RegionalLeagueTypes.RegionalLeague
		ClubFieldIndex.PostField.FOUNDING_YEAR:
			club.founding_year = val


static func _read_coach_line(trainer: Trainer, line: String, i: int) -> void:
	match i:
		TrainerFieldIndex.Field.FIRST_NAME:  trainer.firstname = line
		TrainerFieldIndex.Field.LAST_NAME:   trainer.lastname = line
		TrainerFieldIndex.Field.COMPETENCE:  trainer.competence = line.to_int()
		TrainerFieldIndex.Field.REPUTATION:  trainer.reputation = line.to_int() as TrainerReputationTypes.Reputation
		TrainerFieldIndex.Field.BIRTHDAY:    trainer.birthdate = line


static func _read_manager_line(manager: Manager, line: String, i: int) -> void:
	match i:
		ManagerFieldIndex.Field.FIRST_NAME:  manager.firstname = line
		ManagerFieldIndex.Field.LAST_NAME:   manager.lastname = line
		ManagerFieldIndex.Field.COMPETENCE:  manager.competence = line.to_int()
		ManagerFieldIndex.Field.BIRTHDAY:    manager.birthdate = line


static func _read_reporter_line(reporter: Reporter, line: String, i: int) -> void:
	match i:
		ReporterFieldIndex.Field.BROADCASTER: reporter.broadcaster = line
		ReporterFieldIndex.Field.LAST_NAME:   reporter.lastname = line
		ReporterFieldIndex.Field.FIRST_NAME:  reporter.firstname = line
		ReporterFieldIndex.Field.ATTITUDE:    reporter.attitude = line.to_int() as ReporterAttitudeTypes.Attitude


static func _read_referee_line(referee: Referee, line: String, i: int) -> void:
	match i:
		RefereeFieldIndex.Field.FIRST_NAME:
			referee.firstname = line
		RefereeFieldIndex.Field.LAST_NAME:
			referee.lastname = line
		RefereeFieldIndex.Field.COMPETENCE:
			referee.competence = line.to_int()
		RefereeFieldIndex.Field.STRICTNESS:
			referee.strictness = line.to_int()
		RefereeFieldIndex.Field.DISLIKED_CLUB:
			referee.disliked_club = line.to_int()
		RefereeFieldIndex.Field.CHARACTERISTICS:
			var mask := line.to_int()
			for char_val: int in RefereeCharacteristicTypes.Characteristic.values():
				if mask & char_val:
					referee.characteristics.append(char_val as RefereeCharacteristicTypes.Characteristic)


static func _read_celebrity_line(celebrity: Celebrity, line: String, i: int) -> void:
	match i:
		CelebrityFieldIndex.Field.LAST_NAME:     celebrity.lastname = line
		CelebrityFieldIndex.Field.FIRST_NAME:    celebrity.firstname = line
		CelebrityFieldIndex.Field.FAVORITE_CLUB: celebrity.favorite_club = line.to_int()


static func _read_sponsor_line(sponsor: Sponsor, line: String, i: int) -> void:
	match i:
		SponsorFieldIndex.Field.NAME:   sponsor.name = line
		SponsorFieldIndex.Field.INCOME: sponsor.income_per_season = line.to_int() * 1000


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
