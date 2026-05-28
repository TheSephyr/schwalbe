extends Control

var all_clubs: Array[Club]

@onready var v_box_container: VBoxContainer = $Control/VScrollBar/VBoxContainer
@onready var club_list: ItemList = get_node("ClubList")

func _ready():
	print(Game.all_clubs.size())
	all_clubs = Game.all_clubs
	for club in all_clubs:
		club_list.add_item(club.name)


func _on_club_list_item_selected(index):
	for child in v_box_container.get_children():
		child.queue_free()
	print(all_clubs[index].name)
	for i: int in all_clubs[index].players.size():
		var single_entry: SinglePlayerInClub = preload("res://scenes/single_player_in_club.tscn").instantiate()
		v_box_container.add_child(single_entry)
		single_entry.init(all_clubs[index].players[i], i)
