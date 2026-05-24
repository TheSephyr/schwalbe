class_name CrowdAppealTypes
extends RefCounted

# 1-based index — matches PUBLIKUM lookup table in FieldMappings (index 0 unused)
enum CrowdAppeal {
	NONE            = 0,  # (unused)
	NORMAL          = 1,  # Normal
	CROWD_FAVOURITE = 2,  # Liebling
	HATE_FIGURE     = 3,  # Hassfigur
}
