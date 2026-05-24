class_name ReporterFieldIndex
extends RefCounted

# 0-based field indices for %SECT%REPORTER records in the nation file
enum Field {
	BROADCASTER  = 0,
	LAST_NAME    = 1,
	FIRST_NAME   = 2,
	ATTITUDE     = 3,  # 0=hostile 1=neutral 2=friendly
	FIELD_COUNT  = 4,
}
