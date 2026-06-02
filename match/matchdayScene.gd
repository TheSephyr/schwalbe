extends Control

@onready var matchesHBox: VBoxContainer = $Content/ScrollContainer/MatchesHBox
var matches: Array[Match]
var oneMatchScenes: Array[OneMatch]

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update() -> void:
	matches = Game.player_season().get_current_matchday().matches
	for m:OneMatch in oneMatchScenes:
		matchesHBox.remove_child(m)
		m.queue_free()
		
	oneMatchScenes.clear()
	
	for n:Match in matches: 
		var oneMatch: OneMatch = preload("res://match/one_match.tscn").instantiate()
		oneMatchScenes.append(oneMatch)
		matchesHBox.add_child(oneMatch)
		oneMatch.initMatch(n)


func simulateMatchday():
	Game.current_matchday.simulateMatches()


func _on_button_button_down():
	simulateMatchday()


func _on_ui_next_matchday():
	update()
