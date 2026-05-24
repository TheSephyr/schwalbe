class_name AbbreviationArticleTypes
extends RefCounted

# Index-based values match KUERZEL_ARTIKEL lookup table in FieldMappings
enum Article {
	NONE      = 0,  # Keins
	MASCULINE = 1,  # Der
	FEMININE  = 2,  # Die
}
