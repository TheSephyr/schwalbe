class_name ReporterAttitudeTypes
extends RefCounted

# Index-based values match BOESE_LIEB lookup table in FieldMappings
enum Attitude {
	HOSTILE  = 0,  # Boese
	NEUTRAL  = 1,  # Neutral
	FRIENDLY = 2,  # Lieb
}
