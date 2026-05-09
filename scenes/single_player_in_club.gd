class_name SinglePlayerInClub
extends HBoxContainer

@onready var last_name: Label = $LastName
@onready var first_name: Label = $FirstName
@onready var birthday: Label = $Birthday
@onready var talent: Label = $Talent
@onready var current_ability: Label = $CurrentAbility
@onready var postion: Label = $Postion


var player: Player

func init(player_update: Player):
	player = player_update
	print_debug(player)
	last_name.text = player.lastname
	first_name.text = player.firstname
	birthday.text = player.birthdate
	talent.text = player.talent
	current_ability.text = player.currentAbility
	postion.text = player.position_label()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		GameState.selected_player = player
		get_tree().change_scene_to_file("res://scenes/player/player_scene.tscn")
