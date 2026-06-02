extends Node

enum TransferContext {
	NONE,
	RENEWAL,
	FREE,
	PRECONTRACT,
	NEGOTIATION,
	TRANSFER,
}

var selected_nation_files: Array[String] = ["res://dbfiles/Data.a3/LandDeut.sav"]
var selected_player: Player
var selected_person: RefCounted = null
var last_matchday: Matchday
var transfer_context: TransferContext = TransferContext.NONE
var transfer_source_club: Club = null
var transfer_fee: int = 0
var transfer_results: Array[Dictionary] = []
