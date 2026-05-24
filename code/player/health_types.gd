class_name HealthTypes
extends RefCounted

# Index-based values match GESUNDHEIT lookup table in FieldMappings
enum Health {
	NORMAL         = 0,  # Normal
	ROBUST         = 1,  # Robust
	INJURY_PRONE   = 2,  # Anfaellig
	KNEE_PROBLEMS  = 3,  # Knieprobleme
	QUICK_RECOVERY = 4,  # SchnellWiederFit
	SLOW_RECOVERY  = 5,  # DauertBisWiederFit
	FRAGILE        = 6,  # Wehleidig
}
