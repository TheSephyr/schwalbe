class_name BeardTypes
extends RefCounted

# Bitmask values match SP_HAAR_BART (low nibble) in FieldMappings (field index 29)
enum Beard {
	STUBBLE      = 1,  # Unrasiert
	BEARD        = 2,  # Bart
	MOUSTACHE    = 4,  # Schnurbart
	GOATEE       = 8,  # Ziegenbart
}
