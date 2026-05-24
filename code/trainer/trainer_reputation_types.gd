class_name TrainerReputationTypes
extends RefCounted

# Index-based values match TRAINER_RUF lookup table in FieldMappings
enum Reputation {
	BUDDY       = 0,  # Kumpeltyp
	FUNNY_GUY   = 1,  # LustigerGeselle
	MOTIVATOR   = 2,  # Motivationskuenstler
	PR_MAN      = 3,  # PrMann
	HARD_DRIVER = 4,  # Schleifer
	SCIENTIST   = 5,  # Wissenschaftler
	NONE        = 6,  # Keiner
}
