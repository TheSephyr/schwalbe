class_name RoofCoverTypes
extends RefCounted

# Bitmask values match DACH_BITS dictionary in FieldMappings
enum RoofCover {
	MAIN  = 1,  # Haupt
	AWAY  = 2,  # Gegen
	LEFT  = 4,  # Links
	RIGHT = 8,  # Rechts
}
