class_name PositionTypes
extends RefCounted

# Index-based values match POSITION lookup table in FieldMappings
enum Position {
	NONE                 = 0,   # Keine
	GOALKEEPER           = 1,   # Torwart
	LIBERO               = 2,   # Libero
	CENTRE_BACK          = 3,   # Innenverteidiger
	LEFT_BACK            = 4,   # LinkerVerteidiger
	RIGHT_BACK           = 5,   # RechterVerteidiger
	DEFENSIVE_MIDFIELDER = 6,   # DefensivesMittelfeld
	LEFT_MIDFIELDER      = 7,   # LinkesMittelfeld
	RIGHT_MIDFIELDER     = 8,   # RechtesMittelfeld
	ATTACKING_MIDFIELDER = 9,   # OffensivesMittelfeld
	STRIKER              = 10,  # Stuermer
}
