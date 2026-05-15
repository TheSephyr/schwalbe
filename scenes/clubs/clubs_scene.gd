extends Control

@onready var club_list: VBoxContainer = $Content/MainHBox/LeftPanel/ClubScroll/ClubList
@onready var player_list: VBoxContainer = $Content/MainHBox/RightPanel/PlayerScroll/PlayerList
@onready var club_name_label: Label = $Content/MainHBox/RightPanel/RightHeader/ClubNameLabel


func _ready() -> void:
	for club: Club in Game.first_division_clubs:
		var btn := Button.new()
		btn.text = club.name
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_on_club_selected.bind(club))
		club_list.add_child(btn)


func _on_club_selected(club: Club) -> void:
	club_name_label.text = club.name
	for child in player_list.get_children():
		child.queue_free()
	for player: Player in club.players:
		var entry: SinglePlayerInClub = preload("res://scenes/single_player_in_club.tscn").instantiate()
		player_list.add_child(entry)
		entry.init(player)
