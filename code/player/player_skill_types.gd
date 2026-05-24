class_name PlayerSkillTypes
extends RefCounted

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
