class_name PlayerFieldIndex
extends RefCounted

# 0-based field indices for %SECT%SPIELER records in the nation file
enum Field {
	LAST_NAME              = 0,
	FIRST_NAME             = 1,
	SKIN_COLOR             = 3,
	HAIR_COLOR             = 4,
	AGE                    = 5,
	ABILITY                = 6,
	COUNTRY                = 7,   # value & 127 = country index; value >= 128 → domestic footballer
	MAIN_POSITION          = 8,
	SECONDARY_POSITION_1   = 9,
	SECONDARY_POSITION_2   = 10,
	POSITIVE_SKILLS        = 11,  # bitmask → PlayerSkillTypes.Skill
	NEGATIVE_SKILLS        = 12,  # bitmask → PlayerSkillTypes.Skill
	CHARACTERISTICS        = 13,  # bitmask → PlayerCharacteristicTypes.Characteristic
	CHARACTER              = 14,  # bitmask → PlayerCharacterTypes.Character
	HAS_STAGE_NAME         = 15,
	STAGE_NAME             = 16,  # may be empty string
	FOOT                   = 17,  # 1=Right 2=Left 3=Both
	TALENT                 = 18,  # 1-based
	HEALTH                 = 19,  # 0-based
	CROWD_APPEAL           = 20,  # 1-based
	BIRTHDAY               = 21,
	COUNTRY_2              = 23,
	NATIONAL_PLAYER        = 24,  # 0=none 1=national 2=retired
	CAPTAIN_RETIREMENT     = 27,
	SQUAD_NUMBER           = 28,
	HAIR_BEARD             = 29,  # hair = val>>16 (0-3); beard = val & 0xF → BeardTypes.Beard
	FIELD_COUNT            = 33,  # total field count (indices 0..32)
}
