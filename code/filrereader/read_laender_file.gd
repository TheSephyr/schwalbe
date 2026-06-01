class_name ReadLaenderFile

const SECT := "%SECT%NATION"
const ENDSECT := "%ENDSECT%NATION"


static func load_nations(path: String) -> Array[Nation]:
	var nations: Array[Nation] = []
	var content := EncodingHelper.read_file(path)
	if content.is_empty():
		return nations
	var lines := content.replace("\r\n", "\n").replace("\r", "\n").split("\n")
	var depth := 0
	var current: Nation = null
	var line_counter := 0
	for line: String in lines:
		if line == SECT:
			depth += 1
			if depth == 2:
				current = Nation.new()
				current.id = nations.size()
				line_counter = 0
		elif line == ENDSECT:
			if depth == 2 and current != null:
				nations.append(current)
				current = null
			depth -= 1
		elif depth == 2 and current != null:
			match line_counter:
				0: current.landername = line
				2: current.abkuerzung = line
			line_counter += 1
	return nations
