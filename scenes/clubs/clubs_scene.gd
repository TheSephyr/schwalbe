extends Control

@onready var league_selector: OptionButton = $Content/MainHBox/LeftPanel/LeagueSelector
@onready var club_list: VBoxContainer = $Content/MainHBox/LeftPanel/ClubScroll/ClubList
@onready var player_list: VBoxContainer = $Content/MainHBox/RightPanel/PlayerScroll/PlayerList
@onready var club_name_label: Label = $Content/MainHBox/RightPanel/RightHeader/ClubNameLabel


func _ready() -> void:
	for league: League in Game.leagues:
		league_selector.add_item(league.name)
	league_selector.selected = Game.leagues.find(Game.player_league)
	league_selector.visible = Game.leagues.size() > 1
	_populate_clubs(league_selector.selected)


func _populate_clubs(league_index: int) -> void:
	for child in club_list.get_children():
		child.queue_free()
	for child in player_list.get_children():
		child.queue_free()
	club_name_label.text = "— Verein auswählen —"
	for club: Club in Game.leagues[league_index].clubs:
		var btn := Button.new()
		btn.text = club.name
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_on_club_selected.bind(club))
		club_list.add_child(btn)


func _on_league_selector_item_selected(index: int) -> void:
	_populate_clubs(index)


func _on_club_selected(club: Club) -> void:
	club_name_label.text = club.name
	for child in player_list.get_children():
		child.queue_free()
	for i: int in club.players.size():
		var entry: SinglePlayerInClub = preload("res://scenes/single_player_in_club.tscn").instantiate()
		player_list.add_child(entry)
		entry.init(club.players[i], i)
