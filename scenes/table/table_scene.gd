extends Control

@onready var tableStandings: VBoxContainer = $Content/ScrollContainer/VBoxContainerRankings
@onready var league_selector: OptionButton = $Content/LeagueSelector
var singleTableEntriesScenes: Array[SingleTableEntryScene]


func _ready() -> void:
	EventBus.update_ui.connect(_on_update_ui)
	for league: League in Game.leagues:
		league_selector.add_item(league.name)
	league_selector.selected = Game.leagues.find(Game.player_league)
	league_selector.visible = Game.leagues.size() > 1
	_populate_table(league_selector.selected)


func _on_update_ui() -> void:
	_populate_table(league_selector.selected)


func _populate_table(league_index: int) -> void:
	for entry in singleTableEntriesScenes:
		entry.queue_free()
	singleTableEntriesScenes.clear()
	var season: Season = Game.seasons[league_index]
	for n in season.table.teamStandings:
		var singleEntry: SingleTableEntryScene = preload("res://scenes/table/single_table_entry_scene.tscn").instantiate()
		singleTableEntriesScenes.append(singleEntry)
		tableStandings.add_child(singleEntry)
		singleEntry.setTeamstanding(n)


func _on_league_selector_item_selected(index: int) -> void:
	_populate_table(index)


func _on_ui_next_matchday() -> void:
	_populate_table(league_selector.selected)
