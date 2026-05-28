class_name Stadium
extends RefCounted

var name: String = ""
var city: String = ""
var north: int = 0
var south: int = 0
var west: int = 0
var east: int = 0
var ticket_price: int = GameConfig.TICKET_PRICE_DEFAULT

var scoreboard: ScoreboardTypes.Scoreboard = ScoreboardTypes.Scoreboard.NONE
var pitch_heating: bool = false
var floodlights: bool = false
var home_stand: int = 0
var away_stand: int = 0
var city_location: int = 0
var owned: bool = false
var motorway: bool = false
var tv_tower: bool = false
var main_vip: int = 0
var main_condition: StadiumConditionTypes.Condition = StadiumConditionTypes.Condition.NEW
var away_vip: int = 0
var away_condition: StadiumConditionTypes.Condition = StadiumConditionTypes.Condition.NEW
var left_vip: int = 0
var left_condition: StadiumConditionTypes.Condition = StadiumConditionTypes.Condition.NEW
var right_vip: int = 0
var right_condition: StadiumConditionTypes.Condition = StadiumConditionTypes.Condition.NEW
var roof: int = 0
var running_track: bool = false
var heat_lamps: int = 0
var luxury_boxes: int = 0
var seat_cushions: bool = false
var heated_seats: bool = false
var retractable_pitch: bool = false
var mountains: bool = false
var castle: bool = false
var palace: bool = false


func total() -> int:
	return north + south + west + east
