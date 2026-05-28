class_name PlayerSkillTypes
extends RefCounted

static var LABELS: Dictionary = {
	Skill.HEADING:        "Kopfball",
	Skill.TACKLING:       "Zweikampf",
	Skill.PACE:           "Schnelligkeit",
	Skill.SHOT_POWER:     "Schusskraft",
	Skill.PENALTY:        "Elfmeter",
	Skill.FREE_KICK:      "Freistöße",
	Skill.CROSSING:       "Flanken",
	Skill.FINISHING:      "Torinstinkt",
	Skill.STAMINA:        "Laufstärke",
	Skill.TECHNIQUE:      "Technik",
	Skill.FLAIR:          "Ballzauberer",
	Skill.PLAYMAKER:      "Spielmacher",
	Skill.FLAT_BACK_FOUR: "Viererkette",
	Skill.VISION:         "Spielübersicht",
	Skill.HOLD_UP_PLAY:   "Ball halten",
	Skill.DRIBBLING:      "Dribbling",
}

# Bitmask values match SP_POSITIVE_FAEHIGKEITEN / SP_NEGATIVE_FAEHIGKEITEN in FieldMappings (field indices 11/12)
enum Skill {
	HEADING          = 2,      # Kopfball
	TACKLING         = 4,      # Zweikampf
	PACE             = 8,      # Schnelligkeit
	SHOT_POWER       = 16,     # Schusskraft
	PENALTY          = 32,     # Elfmeter
	FREE_KICK        = 64,     # Freistoesse
	CROSSING         = 128,    # Flanken
	FINISHING        = 256,    # Torinstinkt
	STAMINA          = 512,    # Laufstaerke
	TECHNIQUE        = 1024,   # Technick
	FLAIR            = 2048,   # Ballzauberer
	PLAYMAKER        = 4096,   # Spielmacher
	FLAT_BACK_FOUR   = 8192,   # Viererkette
	VISION           = 16384,  # Spieluebersicht
	HOLD_UP_PLAY     = 32768,  # BallHalten
	DRIBBLING        = 65536,  # Dribbling
}
