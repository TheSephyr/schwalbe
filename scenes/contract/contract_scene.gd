extends Control

@onready var left_content: VBoxContainer = $Content/MainHBox/LeftPanel/LeftMargin/LeftContent
@onready var right_content: VBoxContainer = $Content/MainHBox/RightPanel/RightMargin/RightContent
@onready var left_header_label: Label = $Content/MainHBox/LeftPanel/LeftHeaderPanel/LeftHeaderLabel
@onready var status_label: Label = $Content/StatusLabel
@onready var offer_button: Button = $Content/ButtonRow/OfferButton

var player: Player
var _context: GameState.TransferContext
var _source_club: Club

var _proposed_salary: int
var _proposed_auflauf: int
var _proposed_tor: int
var _proposed_contract_year: int

var _salary_label: Label
var _auflauf_label: Label
var _tor_label: Label
var _year_label: Label

const SALARY_STEP := 10_000
const BONUS_STEP := 1_000
const MIN_CONTRACT_YEAR := 2000
const MAX_CONTRACT_YEAR := 2005


func _ready() -> void:
	player = GameState.selected_player
	_context = GameState.transfer_context
	_source_club = GameState.transfer_source_club
	if player == null:
		return

	_proposed_salary = player.salary
	_proposed_auflauf = player.auflauf_praemie
	_proposed_tor = player.tor_praemie
	var parts := player.contract_end.split(".")
	_proposed_contract_year = int(parts[2]) if parts.size() >= 3 else 2002

	_update_left_header()
	_build_current_contract()
	_build_offer()


func _update_left_header() -> void:
	match _context:
		GameState.TransferContext.FREE:
			left_header_label.text = "Vereinslos"
		GameState.TransferContext.PRECONTRACT:
			var club_name := _source_club.name if _source_club != null else "?"
			left_header_label.text = "Vorvertrag (%s)" % club_name
		GameState.TransferContext.NEGOTIATION:
			var club_name := _source_club.name if _source_club != null else "?"
			left_header_label.text = "Transfer von %s" % club_name
		GameState.TransferContext.TRANSFER:
			var club_name := _source_club.name if _source_club != null else "?"
			left_header_label.text = "Transfer von %s" % club_name
		_:
			left_header_label.text = "Aktueller Vertrag"


func _build_current_contract() -> void:
	_add_info_row(left_content, "Grundgehalt", _format_salary(player.salary))
	_add_info_row(left_content, "Auflaufprämie", _format_salary(player.auflauf_praemie))
	_add_info_row(left_content, "Torprämie", _format_salary(player.tor_praemie))
	_add_info_row(left_content, "Vertragsende", player.contract_end)


func _build_offer() -> void:
	_salary_label = _add_adjust_row(right_content, "Grundgehalt", _format_salary(_proposed_salary),
		func(): _change_salary(-SALARY_STEP),
		func(): _change_salary(SALARY_STEP))
	_auflauf_label = _add_adjust_row(right_content, "Auflaufprämie", _format_salary(_proposed_auflauf),
		func(): _change_auflauf(-BONUS_STEP),
		func(): _change_auflauf(BONUS_STEP))
	_tor_label = _add_adjust_row(right_content, "Torprämie", _format_salary(_proposed_tor),
		func(): _change_tor(-BONUS_STEP),
		func(): _change_tor(BONUS_STEP))
	_year_label = _add_adjust_row(right_content, "Vertragsjahr", str(_proposed_contract_year),
		func(): _change_year(-1),
		func(): _change_year(1))


func _add_info_row(parent: VBoxContainer, label_text: String, value_text: String) -> void:
	var row := HBoxContainer.new()
	var lbl := Label.new()
	lbl.text = label_text
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var val := Label.new()
	val.text = value_text
	row.add_child(lbl)
	row.add_child(val)
	parent.add_child(row)


func _add_adjust_row(parent: VBoxContainer, label_text: String, initial_value: String,
		on_minus: Callable, on_plus: Callable) -> Label:
	var row := HBoxContainer.new()
	var lbl := Label.new()
	lbl.text = label_text
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var minus_btn := Button.new()
	minus_btn.text = "-"
	minus_btn.pressed.connect(on_minus)
	var val_lbl := Label.new()
	val_lbl.text = initial_value
	val_lbl.custom_minimum_size = Vector2(90, 0)
	val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var plus_btn := Button.new()
	plus_btn.text = "+"
	plus_btn.pressed.connect(on_plus)
	row.add_child(lbl)
	row.add_child(minus_btn)
	row.add_child(val_lbl)
	row.add_child(plus_btn)
	parent.add_child(row)
	return val_lbl


func _change_salary(delta: int) -> void:
	_proposed_salary = clampi(_proposed_salary + delta, GameConfig.CONTRACT_MIN_SALARY, GameConfig.CONTRACT_MAX_SALARY)
	_salary_label.text = _format_salary(_proposed_salary)


func _change_auflauf(delta: int) -> void:
	_proposed_auflauf = clampi(_proposed_auflauf + delta, 0, GameConfig.CONTRACT_MAX_APPEARANCE_BONUS)
	_auflauf_label.text = _format_salary(_proposed_auflauf)


func _change_tor(delta: int) -> void:
	_proposed_tor = clampi(_proposed_tor + delta, 0, GameConfig.CONTRACT_MAX_APPEARANCE_BONUS)
	_tor_label.text = _format_salary(_proposed_tor)


func _change_year(delta: int) -> void:
	_proposed_contract_year = clampi(_proposed_contract_year + delta, MIN_CONTRACT_YEAR, MAX_CONTRACT_YEAR)
	_year_label.text = str(_proposed_contract_year)


func _on_offer_pressed() -> void:
	if _proposed_salary < player.salary:
		status_label.text = "Angebot abgelehnt. Mindestgehalt: %s" % _format_salary(player.salary)
		return

	match _context:
		GameState.TransferContext.RENEWAL:
			player.salary = _proposed_salary
			player.auflauf_praemie = _proposed_auflauf
			player.tor_praemie = _proposed_tor
			var parts := player.contract_end.split(".")
			if parts.size() >= 3:
				player.contract_end = "%s.%s.%d" % [parts[0], parts[1], _proposed_contract_year]
			status_label.text = "Vertrag verlängert!"
		GameState.TransferContext.FREE:
			Game.sign_player_immediately(player, null, _proposed_salary, _proposed_auflauf, _proposed_tor, _proposed_contract_year)
			status_label.text = "Spieler sofort verpflichtet!"
		GameState.TransferContext.PRECONTRACT:
			Game.add_pending_transfer(player, _source_club, _proposed_salary, _proposed_auflauf, _proposed_tor, _proposed_contract_year)
			status_label.text = "Vorvertrag abgeschlossen! Spieler kommt zur neuen Saison."
		GameState.TransferContext.NEGOTIATION:
			Game.start_transfer_negotiation(player, _source_club, _proposed_salary, _proposed_auflauf, _proposed_tor, _proposed_contract_year, GameState.transfer_fee)
			status_label.text = "Verhandlung gestartet! Entscheidung in 2 Wochen."
		GameState.TransferContext.TRANSFER:
			Game.sign_player_immediately(player, _source_club, _proposed_salary, _proposed_auflauf, _proposed_tor, _proposed_contract_year)
			status_label.text = "Spieler wechselt sofort!"

	offer_button.disabled = true


func _on_back_pressed() -> void:
	if _context == GameState.TransferContext.RENEWAL:
		get_tree().change_scene_to_file("res://scenes/club/club.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/player_search/player_search_scene.tscn")


func _format_salary(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.2f Mio" % (amount / 1_000_000.0)
	if amount >= 1_000:
		return "%d.%03d" % [amount / 1000, amount % 1000]
	return "%d DM" % amount
