class_name Reporter
extends RefCounted

var broadcaster: String = ""
var lastname: String = ""
var firstname: String = ""
var attitude: ReporterAttitudeTypes.Attitude = ReporterAttitudeTypes.Attitude.NEUTRAL


func full_name() -> String:
	return firstname + " " + lastname
