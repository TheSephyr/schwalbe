class_name SinglePlayerInClub
extends PanelContainer

@onready var last_name: Label = $MarginContainer/HBoxContainer/LastName
@onready var first_name: Label = $MarginContainer/HBoxContainer/FirstName
@onready var birthday: Label = $MarginContainer/HBoxContainer/Birthday
@onready var talent: Label = $MarginContainer/HBoxContainer/Talent
@onready var current_ability: Label = $MarginContainer/HBoxContainer/CurrentAbility
@onready var postion: Label = $MarginContainer/HBoxContainer/Postion
@onready var contract_end: Label = $MarginContainer/HBoxContainer/ContractEnd
@onready var salary: Label = $MarginContainer/HBoxContainer/Salary

var player: Player
var _popup: PopupMenu


func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_popup = PopupMenu.new()
	_popup.add_item("Spieler Info", 0)
	_popup.add_item("Vertragsverhandlung", 1)
	_popup.id_pressed.connect(_on_popup_id_pressed)
	add_child(_popup)


func init(player_update: Player, row_index: int) -> void:
	player = player_update
	last_name.text = player.lastname
	first_name.text = player.firstname
	birthday.text = player.birthdate
	talent.text = player.talent
	current_ability.text = player.currentAbility
	postion.text = player.position_label()
	var parts := player.contract_end.split(".")
	contract_end.text = parts[2] if parts.size() >= 3 else "–"
	salary.text = _format_salary(player.salary)
	_apply_row_style(row_index)


func _apply_row_style(index: int) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.91, 0.9, 0.82, 1) if index % 2 == 0 else Color(0.85, 0.84, 0.74, 1)
	add_theme_stylebox_override("panel", style)


func _format_salary(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d" % [amount / 1000, amount % 1000]
	return "%d DM" % amount


func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or not event.pressed:
		return
	if event.button_index == MOUSE_BUTTON_LEFT:
		GameState.selected_player = player
		get_tree().change_scene_to_file("res://scenes/player/player_scene.tscn")
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		_popup.position = Vector2i(get_global_mouse_position())
		_popup.popup()


func _on_popup_id_pressed(id: int) -> void:
	GameState.selected_player = player
	if id == 0:
		get_tree().change_scene_to_file("res://scenes/player/player_scene.tscn")
	else:
		GameState.transfer_context = GameState.TransferContext.RENEWAL
		GameState.transfer_source_club = null
		get_tree().change_scene_to_file("res://scenes/contract/contract_scene.tscn")
