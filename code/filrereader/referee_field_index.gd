class_name RefereeFieldIndex
extends RefCounted

# 0-based field indices for %SECT%SCHIRI / %SECT%ISCHIRI records in the nation file
enum Field {
	FIRST_NAME      = 0,
	LAST_NAME       = 1,
	COMPETENCE      = 2,
	STRICTNESS      = 3,
	DISLIKED_CLUB   = 4,
	CHARACTERISTICS = 5,  # bitmask → RefereeCharacteristicTypes.Characteristic
	FIELD_COUNT     = 6,
}
