class_name BoardTypes
extends RefCounted

# Index-based values match VORSTAND lookup table in FieldMappings
enum Board {
	VOLATILE  = 0,  # Pulverfass
	UNSTABLE  = 1,  # Schleudersitz
	NERVOUS   = 2,  # Nervoes
	NORMAL    = 3,  # Normal
	COMPOSED  = 4,  # Souveraen
	LOYAL     = 5,  # Treu
}
