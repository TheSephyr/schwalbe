extends Node

@onready var playerList: VBoxContainer = $PlayerList

# Called when the node enters the scene tree for the first time.
func _ready():
	for player:Player in Game.player_club.players:
		var playerLabel: Label = Label.new()
		playerLabel.text = player.lastname + ", " + player.firstname
		playerList.add_child(playerLabel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
