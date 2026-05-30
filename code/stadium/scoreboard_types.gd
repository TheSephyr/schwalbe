class_name ScoreboardTypes
extends RefCounted

# Index-based values match ANZEIGETAFEL lookup table in FieldMappings
enum Scoreboard {
	NONE         = 0,  # KeineTafel
	GOAL_SIGNS   = 1,  # Torschilder
	SMALL_LED    = 2,  # KleineLedTafel
	LARGE_LED    = 3,  # GrosseLedTafel
	VIDEO_SCREEN = 4,  # Videowand
}
