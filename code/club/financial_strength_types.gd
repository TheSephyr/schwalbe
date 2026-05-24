class_name FinancialStrengthTypes
extends RefCounted

# Index-based values match FINANZKRAFT lookup table in FieldMappings
enum FinancialStrength {
	MINIMAL = 0,  # Minimal
	POOR    = 1,  # Schlecht
	LIMITED = 2,  # Wenig
	SOLID   = 3,  # Solide
	GOOD    = 4,  # Gut
	RICH    = 5,  # Reich
	BLESSED = 6,  # Gesegnet
}
