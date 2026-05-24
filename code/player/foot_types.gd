class_name FootTypes
extends RefCounted

# 1-based index — matches FUSS lookup table in FieldMappings (index 0 unused)
enum Foot {
	NONE  = 0,  # (unused)
	RIGHT = 1,  # Rechts
	LEFT  = 2,  # Links
	BOTH  = 3,  # Beide
}
