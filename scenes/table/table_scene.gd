extends Control

@onready var tableStandings: VBoxContainer = $VBoxContainerRankings
var singleTableEntriesScenes: Array[SingleTableEntryScene]

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.update_ui.connect(_on_update_ui)
	update_table()

func _on_update_ui() -> void:
	update_table()


func update_table() -> void:
	for entryScene in singleTableEntriesScenes:
		tableStandings.remove_child(entryScene)
	for n in Game.current_season.table.teamStandings:
		var singleEntry: SingleTableEntryScene = preload("res://scenes/table/single_table_entry_scene.tscn").instantiate()
		singleTableEntriesScenes.append(singleEntry)
		tableStandings.add_child(singleEntry)
		singleEntry.setTeamstanding(n)


func _on_ui_next_matchday():
	print_debug("On ui next Matchday")
	update_table()
