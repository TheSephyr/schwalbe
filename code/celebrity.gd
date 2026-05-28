class_name Celebrity
extends RefCounted

var lastname: String = ""
var firstname: String = ""
var favorite_club: int = 0


func full_name() -> String:
	return firstname + " " + lastname
