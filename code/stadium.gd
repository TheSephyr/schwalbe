class_name Stadium
extends RefCounted

var name: String = ""
var city: String = ""
var north: int = 0
var south: int = 0
var west: int = 0
var east: int = 0
var ticket_price: int = GameConfig.TICKET_PRICE_DEFAULT


func total() -> int:
	return north + south + west + east
