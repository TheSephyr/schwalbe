class_name KitPatternTypes
extends RefCounted

# Index-based values match TRIKOT_MUSTER lookup table in FieldMappings
enum KitPattern {
	PLAIN              = 0,  # Neutral
	VERTICAL_STRIPES   = 1,  # Laengs
	HORIZONTAL_STRIPES = 2,  # Quer
	HALF_HALF          = 3,  # HalbHalb
	SHOULDER           = 4,  # Schulter
	CHEST_STRIPE       = 5,  # Brustring
	SLEEVES            = 6,  # Aermel
	CENTRE_STRIPE      = 7,  # Mittelstreifen
	CHECKED            = 8,  # Kariert
	DIAGONAL           = 9,  # Schraeg
}
