class_name PlayerCharacteristicTypes
extends RefCounted

# Bitmask values match SP_EIGENSCHAFTEN in FieldMappings (field index 13)
enum Characteristic {
	FIGHTER          = 2,      # Kaempfernatur
	HARD_TRAINER     = 4,      # Trainingsweltmeister
	LAZY_TRAINER     = 8,      # TrainingsfaulerSpieler
	DIRTY_PLAYER     = 16,     # Treter
	FAIR_PLAYER      = 32,     # FairerSpieler
	CRYBABY          = 64,     # Mimose
	CUNNING          = 128,    # Schlitzohr
	SPECIALIST       = 256,    # Spezialist
	ALL_ROUNDER      = 512,    # Allrounder
	FLEXIBLE         = 1024,   # FlexiblerSpieler
	REFS_DARLING     = 2048,   # Schiriliebling
	HOME_PLAYER      = 4096,   # Heimspieler
	FAIR_WEATHER     = 8192,   # Schoenwetterfussballer
	SUPER_SUB        = 16384,  # Joker
	EGOIST           = 32768,  # Egoist
	CAREFREE         = 65536,  # BruderLeichtfuss
}
