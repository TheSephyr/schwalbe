extends Node

var selected_player: Player
var last_matchday: Matchday
var transfer_context: String = ""
var transfer_source_club: Club = null
var transfer_fee: int = 0
var transfer_results: Array[Dictionary] = []
