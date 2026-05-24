class_name PlayerCharacterTypes
extends RefCounted

# Bitmask values match SP_CHARAKTER in FieldMappings (field index 14)
enum Character {
	LEADER           = 2,      # Fuehrungsperson
	HOTHEAD          = 4,      # Hitzkopf
	CHEERFUL         = 8,      # Frohnatur
	ICE_COLD         = 16,     # MannOhneNerven
	NERVOUS_WRECK    = 32,     # Nervenbuendel
	LAID_BACK        = 64,     # Phlegmatiker
	MERCENARY        = 128,    # Geldgeier
	CLUB_LOYALIST    = 256,    # Vereinsanhaenger
	MODEL_PRO        = 512,    # Musterprofi
	DRAMA_KING       = 1024,   # Skandalnudel
	SENSITIVE        = 2048,   # Sensibelchen
	PRIMA_DONNA      = 4096,   # Staralueren
	TEEN_STAR        = 8192,   # TeenieStar
	TROUBLEMAKER     = 16384,  # Unruhestifter
	SULKY            = 32768,  # Leberwurst
	TEAM_INTEGRATOR  = 65536,  # Integrationsfigur
}
