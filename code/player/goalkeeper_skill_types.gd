class_name GoalkeeperSkillTypes
extends RefCounted

# Bitmask values match TORWART_FAEHIGKEITEN in FieldMappings
enum Skill {
	PENALTY_SAVER    = 2,    # Elfmetertoeter
	REFLEXES         = 4,    # StarkeReflexe
	RUSHING_OUT      = 8,    # Herauslaufen
	CROSS_HANDLING   = 16,   # Flanken
	PUNCHING         = 32,   # Fausten
	SURE_HANDS       = 64,   # Ballsicherheit
	PACE             = 128,  # Schnelligkeit
	LONG_KICKS       = 256,  # WeiteAbschlaege
	LONG_THROWS      = 512,  # WeiteAbwuerfe
}
