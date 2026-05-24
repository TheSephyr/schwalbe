class_name StadiumFieldIndex
extends RefCounted

# 0-based field indices for %SECT%STADION records in the nation file
enum Field {
	NAME              = 0,
	CITY              = 1,
	SCOREBOARD        = 2,
	PITCH_HEATING     = 3,
	FLOODLIGHTS       = 6,
	HOME_STAND        = 7,
	AWAY_STAND        = 8,
	CITY_LOCATION     = 9,
	OWNED             = 10,
	MOTORWAY          = 11,
	TV_TOWER          = 12,
	MAIN_STANDING     = 13,
	MAIN_SEATING      = 14,
	MAIN_VIP          = 15,
	MAIN_CONDITION    = 16,
	AWAY_STANDING     = 17,
	AWAY_SEATING      = 18,
	AWAY_VIP          = 19,
	AWAY_CONDITION    = 20,
	LEFT_STANDING     = 21,
	LEFT_SEATING      = 22,
	LEFT_VIP          = 23,
	LEFT_CONDITION    = 24,
	RIGHT_STANDING    = 25,
	RIGHT_SEATING     = 26,
	RIGHT_VIP         = 27,
	RIGHT_CONDITION   = 28,
	ROOF              = 29,  # bitmask: 1=Main 2=Away 4=Left 8=Right
	RUNNING_TRACK     = 30,
	HEAT_LAMPS        = 31,  # bitmask same as ROOF
	LUXURY_BOXES      = 32,
	SEAT_CUSHIONS     = 33,
	HEATED_SEATS      = 34,
	RETRACTABLE_PITCH = 35,
	MOUNTAINS         = 36,
	CASTLE            = 37,
	PALACE            = 38,
	FIELD_COUNT       = 39,
}
