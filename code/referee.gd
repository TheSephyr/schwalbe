class_name Referee
extends RefCounted

var firstname: String = ""
var lastname: String = ""
var competence: int = 0
var strictness: int = 0
var disliked_club: int = 0
var characteristics: Array[RefereeCharacteristicTypes.Characteristic] = []


func full_name() -> String:
	return firstname + " " + lastname
