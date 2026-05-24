class_name HairStyleTypes
extends RefCounted

# 2-bit value from SP_HAAR_BART field (val >> 16) — matches HAAR lookup table in FieldMappings
enum HairStyle {
	VERY_SHORT = 0,  # ExtremKurz
	SHORT      = 1,  # Kurz
	FRIZZY     = 2,  # Wuschelkopf
	LONG       = 3,  # Lang
}
