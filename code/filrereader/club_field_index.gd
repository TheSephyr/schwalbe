class_name ClubFieldIndex
extends RefCounted

# 0-based field indices for %SECT%VEREIN records in the nation file

# Header fields (before %SECT%TRAINER block)
enum HeaderField {
	COUNTRY        = 0,
	CLUB_NAME      = 1,
	ABBREVIATION   = 2,
	CHANT          = 3,
	FAN_NAME       = 4,
	HEADER_COUNT   = 5,
}

# Post-manager fields (after manager block)
enum PostField {
	HOME_KIT_COLOR1_PATTERN  = 0,
	HOME_KIT_COLOR2          = 1,
	HOME_KIT_SHORTS_COLOR    = 2,
	HOME_KIT_SOCKS           = 3,
	AWAY_KIT_COLOR1_PATTERN  = 4,
	AWAY_KIT_COLOR2          = 5,
	AWAY_KIT_SHORTS_COLOR    = 6,
	AWAY_KIT_SOCKS           = 7,
	BALANCE                  = 8,
	ABBREVIATION_ARTICLE     = 9,
	FAN_ATTENDANCE           = 10,
	FAN_TYPE                 = 11,
	FAN_FRIENDSHIP_WITH      = 12,
	ARCH_RIVAL               = 13,
	BOARD                    = 14,
	CUP_TEAM                 = 15,
	MAP_RED_X                = 16,
	MAP_UNKNOWN              = 17,
	MAP_GREEN_X              = 18,
	MAP_GREEN_Y              = 19,
	UNKNOWN_21               = 20,
	OPPOSITION               = 21,
	AMATEUR_SECTION_OF       = 22,
	PRO_SECTION_OF           = 23,
	FINANCIAL_STRENGTH       = 24,
	MAX_FAN_ATTENDANCE       = 25,
	HOOLIGANS                = 26,
	MEDIA_CITY               = 27,
	ALL_TIME_GOALS           = 28,
	ALL_TIME_GOALS_AGAINST   = 29,
	ALL_TIME_MATCHES         = 30,
	ALL_TIME_POINTS          = 31,
	CHAIRMAN_LAST_NAME       = 32,
	CHAIRMAN_FIRST_NAME      = 33,
	CHAIRMAN_BIRTHDAY        = 34,
	PUBLIC_COMPANY           = 35,
	TITLES_CHAMPIONSHIPS     = 36,
	TITLES_CUPS              = 37,
	TITLES_LEAGUE_CUPS       = 38,
	TITLES_EUROPA_LEAGUES    = 39,
	TITLES_CHAMPIONS_LEAGUES = 40,
	TITLES_WORLD_CUPS        = 41,
	REGIONAL_LEAGUE_FROM_2000 = 42,
	FOUNDING_YEAR            = 43,
	POST_FIELD_COUNT         = 51,  # indices 0..50 (50 = player count)
}
