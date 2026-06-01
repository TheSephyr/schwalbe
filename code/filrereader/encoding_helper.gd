class_name EncodingHelper


# Convert ISO-8859-1 bytes to a UTF-8 PackedByteArray.
# 0x00-0x7F are identical in both encodings and copied as-is.
# 0x80-0xFF become two-byte UTF-8 sequences (0xC0|b>>6, 0x80|b&0x3F).
static func _latin1_to_utf8(bytes: PackedByteArray) -> PackedByteArray:
	var utf8 := PackedByteArray()
	utf8.resize(bytes.size() * 2)
	var out := 0
	for b in bytes:
		if b < 0x80:
			utf8[out] = b
			out += 1
		else:
			utf8[out] = 0xC0 | (b >> 6)
			out += 1
			utf8[out] = 0x80 | (b & 0x3F)
			out += 1
	utf8.resize(out)
	return utf8


static func read_latin1_file(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: " + path)
		return ""
	var bytes: PackedByteArray = file.get_buffer(file.get_length())
	file.close()
	return _latin1_to_utf8(bytes).get_string_from_utf8()


static func _is_valid_utf8(bytes: PackedByteArray) -> bool:
	var i := 0
	while i < bytes.size():
		var b := bytes[i]
		var extra := 0
		if b < 0x80:
			extra = 0
		elif b < 0xC0:
			return false
		elif b < 0xE0:
			extra = 1
		elif b < 0xF0:
			extra = 2
		elif b < 0xF8:
			extra = 3
		else:
			return false
		for _j in range(extra):
			i += 1
			if i >= bytes.size() or (bytes[i] & 0xC0) != 0x80:
				return false
		i += 1
	return true


static func read_file(path: String) -> String:
	var bytes := FileAccess.get_file_as_bytes(path)
	if _is_valid_utf8(bytes):
		return bytes.get_string_from_utf8()
	return _latin1_to_utf8(bytes).get_string_from_utf8()
