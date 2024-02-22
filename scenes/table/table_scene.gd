extends Control

@onready var tableStandings: VBoxContainer = $VBoxContainerRankings
var singleTableEntriesScenes: Array[SingleTableEntryScene]

# Called when the node enters the scene tree for the first time.
func _ready():
	updateTable()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func updateTable() -> void:
	for entryScene in singleTableEntriesScenes:
		tableStandings.remove_child(entryScene)
	for n in Game.currentSeason.table.teamStandings:
		var oneMatch: OneMatch = preload("res://match/one_match.tscn").instantiate()
		var singleEntry: SingleTableEntryScene = preload("res://scenes/table/single_table_entry_scene.tscn").instantiate()
		singleTableEntriesScenes.append(singleEntry)
		tableStandings.add_child(singleEntry)
		singleEntry.setTeamstanding(n)


func _on_ui_next_matchday():
	print_debug("On ui next Matchday")
	updateTable()
