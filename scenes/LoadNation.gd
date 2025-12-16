extends Control

const PLAYER_MARKER_START: String = "%SECT%SPIELER"
const PLAYER_MARKER_END: String = "%ENDSECT%SPIELER"

const CLUB_MARKER_START: String = "%SECT%VEREIN"
const CLUB_MARKER_END: String = "%ENDSECT%VEREIN"

const COACH_MARKER_START: String = "%SECT%TRAINER"
const COACH_MARKER_END: String = "%ENDSECT%TRAINER"

const MANAGER_MARKER_START: String = "%SECT%MANAGER"
const MANAGER_MARKER_END: String = "%ENDSECT%MANAGER"

const NATION_MARKER_START: String = "%SECT%LAND"

const STADION_MARKER_START: String = "%SECT%STADION"
const STADION_MARKER_END: String = "%ENDSECT%STADION"

var allPlayer: Array[Player]
var all_clubs: Array[Club]
@onready var clubList: ItemList = get_node("ClubList")
@onready var playerList: ItemList = get_node("PlayerList")
@onready var allPlayerGridContainer: GridContainer = get_node("ScrollContainer/AllPlayerGridContainer")
var player_instance: Player


# Called when the node enters the scene tree for the first time.
func _ready():
	print(Game.all_clubs.size())
	all_clubs = Game.all_clubs
	for club in all_clubs:
		clubList.add_item(club.name)
	#clubList.add_item("FromCode")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_club_list_item_selected(index):
	print(all_clubs[index].name)
	playerList.clear()
	var counter: int = 0
	for childNode in allPlayerGridContainer.get_children():
		if(counter > 5):
			allPlayerGridContainer.remove_child(childNode)
			childNode.queue_free()
		counter = counter + 1
		
	for player in all_clubs[index].players:
		
		var playerLastNameLabel: Label = Label.new()
		var playerFirstNameLabel = Label.new()
		var playerBirthdayLabel = Label.new()
		var playerTalentLabel = Label.new()
		var playerCurrentAbilityLabel = Label.new()
		var playerPositionLabel = Label.new()
		
		playerLastNameLabel.text = player.lastname
		playerFirstNameLabel.text = player.firstname
		playerBirthdayLabel.text = player.birthdate
		playerTalentLabel.text = player.talent
		playerCurrentAbilityLabel.text = player.currentAbility
		playerPositionLabel.text = player.position
		

		allPlayerGridContainer.add_child(playerLastNameLabel)
		allPlayerGridContainer.add_child(playerFirstNameLabel)
		allPlayerGridContainer.add_child(playerBirthdayLabel)
		allPlayerGridContainer.add_child(playerTalentLabel)
		allPlayerGridContainer.add_child(playerCurrentAbilityLabel)
		allPlayerGridContainer.add_child(playerPositionLabel)
		
		
		playerList.add_item(player.lastname)
	pass # Replace with function body.
