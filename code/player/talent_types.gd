class_name TalentTypes
extends RefCounted

# 1-based index — matches TALENT lookup table in FieldMappings (index 0 unused)
enum Talent {
	NONE          = 0,  # (unused)
	WONDERKID     = 1,  # Megatalent
	TALENTED      = 2,  # Talent
	NORMAL        = 3,  # Normal
	LIMITED       = 4,  # WenigBegabt
	TWO_LEFT_FEET = 5,  # ZweiLinkeFuesse
}
