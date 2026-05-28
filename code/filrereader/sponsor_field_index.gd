class_name SponsorFieldIndex
extends RefCounted

# 0-based field indices for %SECT%SPONSOR records in the nation file
enum Field {
	NAME        = 0,
	INCOME      = 6,  # in thousands DM; multiply by 1000 for actual DM value
	FIELD_COUNT = 19,
}
