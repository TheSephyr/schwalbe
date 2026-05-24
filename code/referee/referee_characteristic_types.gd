class_name RefereeCharacteristicTypes
extends RefCounted

# Bitmask values match SC_EIGENSCHAFTEN in FieldMappings (field index 5)
enum Characteristic {
	FAVORS_HOME_TEAM  = 1,   # Heimschiedsrichter
	FAVORS_AWAY_TEAM  = 2,   # Gastschiedsrichter
	HATES_COMPLAINING = 4,   # HasstMeckern
	HATES_TIME_WASTING = 8,  # HasstZeitspiel
	HATES_COACHING    = 16,  # HasstCoaching
}
