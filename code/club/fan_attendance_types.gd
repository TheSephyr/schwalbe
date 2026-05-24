class_name FanAttendanceTypes
extends RefCounted

# Index-based values match FANAUFKOMMEN lookup table in FieldMappings
enum FanAttendance {
	MASSIVE     = 0,  # WahreHorden
	VERY_HIGH   = 1,  # SehrHoch
	HIGH        = 2,  # Hoch
	AVERAGE     = 3,  # Durchschnittlich
	MODEST      = 4,  # Bescheiden
	POOR        = 5,  # Aermlich
	ALMOST_NONE = 6,  # Fans?
}
