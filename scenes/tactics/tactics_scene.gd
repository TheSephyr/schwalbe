extends Control

const SPIELSTIL_DESC: Array[String] = [
	"Kompaktes Defensivspiel. Die Mannschaft steht tief und sichert ab.",
	"Ausgewogenes Spiel. Angriff und Verteidigung im Gleichgewicht.",
	"Offensives Pressing. Die Mannschaft sucht aktiv den Torabschluss.",
]
const PRESSING_DESC: Array[String] = [
	"Tiefes Pressing. Kräfte sparen, Konter abwarten.",
	"Mittleres Pressing. Ausgewogene Laufarbeit.",
	"Hohes Pressing. Ballgewinn früh im Angriff — konditionszehrend.",
]

@onready var defensiv_btn: Button = $Content/SpielstilPanel/Margin/VBox/ButtonRow/DefensivBtn
@onready var ausgewogen_btn: Button = $Content/SpielstilPanel/Margin/VBox/ButtonRow/AusgewogenBtn
@onready var offensiv_btn: Button = $Content/SpielstilPanel/Margin/VBox/ButtonRow/OffensivBtn
@onready var spielstil_desc: Label = $Content/SpielstilPanel/Margin/VBox/DescLabel

@onready var tief_btn: Button = $Content/PressingPanel/Margin/VBox/ButtonRow/TiefBtn
@onready var mittel_btn: Button = $Content/PressingPanel/Margin/VBox/ButtonRow/MittelBtn
@onready var hoch_btn: Button = $Content/PressingPanel/Margin/VBox/ButtonRow/HochBtn
@onready var pressing_desc: Label = $Content/PressingPanel/Margin/VBox/DescLabel

var _spielstil_btns: Array[Button]
var _pressing_btns: Array[Button]


func _ready() -> void:
	_spielstil_btns = [defensiv_btn, ausgewogen_btn, offensiv_btn]
	_pressing_btns = [tief_btn, mittel_btn, hoch_btn]
	_refresh_spielstil()
	_refresh_pressing()


func _on_spielstil_pressed(idx: int) -> void:
	Game.player_club.spielstil = idx
	_refresh_spielstil()


func _on_pressing_pressed(idx: int) -> void:
	Game.player_club.pressing = idx
	_refresh_pressing()


func _refresh_spielstil() -> void:
	var sel: int = Game.player_club.spielstil
	for i: int in _spielstil_btns.size():
		_spielstil_btns[i].button_pressed = (i == sel)
	spielstil_desc.text = SPIELSTIL_DESC[sel]


func _refresh_pressing() -> void:
	var sel: int = Game.player_club.pressing
	for i: int in _pressing_btns.size():
		_pressing_btns[i].button_pressed = (i == sel)
	pressing_desc.text = PRESSING_DESC[sel]
