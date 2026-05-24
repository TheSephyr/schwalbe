class_name StadiumConditionTypes
extends RefCounted

# Index-based values match STADION_ZUSTAND lookup table in FieldMappings
enum Condition {
	NEW         = 0,  # Neu
	ALMOST_NEW  = 1,  # FastNeu
	OUTDATED    = 2,  # Unmodern
	DUSTY       = 3,  # Angestaubt
	DILAPIDATED = 4,  # Baufaellig
	ROTTING     = 5,  # Vermodert
	CRUMBLING   = 6,  # Verfallen
}
