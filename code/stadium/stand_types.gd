class_name StandTypes
extends RefCounted

# Index-based values match TRIBUNEN_TYP lookup table in FieldMappings
enum Stand {
	MAIN  = 0,  # Haupt
	AWAY  = 1,  # Gegen
	LEFT  = 2,  # Links
	RIGHT = 3,  # Rechts
}
