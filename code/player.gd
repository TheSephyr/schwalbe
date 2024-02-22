class_name Player
	
# Player attributes
var firstname : String
var lastname : String
var birthdate : String
var talent : String
var currentAbility: String
var position : String


func _to_string():
	return "(" + lastname + ", " + firstname + ")"

# Constructor
#func _init(firstname, lastname, birthdate, talent, position):
#	self.firstname = firstname
#	self.lastname = lastname
#	self.birthdate = birthdate
#	self.talent = talent
#	self.position = position
