class_name Trainer
extends RefCounted

var lastname: String = ""
var firstname: String = ""
var birthdate: String = ""
var competence: int = 0
var reputation: TrainerReputationTypes.Reputation = TrainerReputationTypes.Reputation.NONE


func _init(p_lastname: String, p_firstname: String, p_birthdate: String) -> void:
	lastname = p_lastname
	firstname = p_firstname
	birthdate = p_birthdate


func age(current_year: int) -> int:
	var parts := birthdate.split(".")
	if parts.size() < 3:
		return 0
	return current_year - parts[2].to_int()


func full_name() -> String:
	return firstname + " " + lastname
