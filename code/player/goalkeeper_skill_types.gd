class_name GoalkeeperSkillTypes
extends RefCounted

static var LABELS: Dictionary = {
	Skill.PENALTY_SAVER:  "Elfmettöter",
	Skill.REFLEXES:       "Starke Reflexe",
	Skill.RUSHING_OUT:    "Herauslaufen",
	Skill.CROSS_HANDLING: "Flanken",
	Skill.PUNCHING:       "Fausten",
	Skill.SURE_HANDS:     "Ballsicherheit",
	Skill.PACE:           "Schnelligkeit",
	Skill.LONG_KICKS:     "Weite Abschläge",
	Skill.LONG_THROWS:    "Weite Abwürfe",
}

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
