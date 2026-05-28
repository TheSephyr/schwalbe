extends Control

@onready var type_label: Label = $Content/VBox/TitlePanel/TypeLabel
@onready var name_label: Label = $Content/VBox/NamePanel/NameMargin/NameLabel
@onready var detail_grid: GridContainer = $Content/VBox/DetailPanel/DetailMargin/DetailGrid


func _ready() -> void:
	var person: RefCounted = GameState.selected_person
	if person is Manager:
		_show_manager(person as Manager)
	elif person is Trainer:
		_show_trainer(person as Trainer)
	elif person is Referee:
		_show_referee(person as Referee)
	elif person is Reporter:
		_show_reporter(person as Reporter)
	elif person is Celebrity:
		_show_celebrity(person as Celebrity)


func _show_manager(m: Manager) -> void:
	type_label.text = "Manager"
	name_label.text = m.full_name()
	_add_row("Geburtstag", m.birthdate)
	_add_row("Alter", str(m.age(Game.current_date.year)) + " Jahre")
	_add_row("Kompetenz", str(m.competence))


func _show_trainer(t: Trainer) -> void:
	type_label.text = "Trainer"
	name_label.text = t.full_name()
	_add_row("Geburtstag", t.birthdate)
	_add_row("Alter", str(t.age(Game.current_date.year)) + " Jahre")
	_add_row("Kompetenz", str(t.competence))
	_add_row("Ruf", _trainer_reputation(t.reputation))


func _show_referee(r: Referee) -> void:
	type_label.text = "Schiedsrichter"
	name_label.text = r.full_name()
	_add_row("Kompetenz", str(r.competence))
	_add_row("Strenge", str(r.strictness))
	if r.disliked_club > 0:
		_add_row("Abneigung gegen", _club_name(r.disliked_club))
	for c: RefereeCharacteristicTypes.Characteristic in r.characteristics:
		_add_row("Eigenschaft", _referee_char(c))


func _show_reporter(r: Reporter) -> void:
	type_label.text = "Reporter"
	name_label.text = r.full_name()
	_add_row("Sender", r.broadcaster)
	_add_row("Haltung", _reporter_attitude(r.attitude))


func _show_celebrity(c: Celebrity) -> void:
	type_label.text = "Promi"
	name_label.text = c.full_name()
	if c.favorite_club > 0:
		_add_row("Lieblingsverein", _club_name(c.favorite_club))


func _add_row(label_text: String, value_text: String) -> void:
	var lbl := Label.new()
	lbl.text = label_text
	lbl.add_theme_font_size_override("font_size", 12)
	lbl.modulate = Color(0.4, 0.4, 0.4, 1.0)
	detail_grid.add_child(lbl)
	var val := Label.new()
	val.text = value_text
	val.add_theme_font_size_override("font_size", 12)
	detail_grid.add_child(val)


func _club_name(index: int) -> String:
	if index > 0 and index <= Game.all_clubs.size():
		return Game.all_clubs[index - 1].name
	return str(index)


func _trainer_reputation(rep: TrainerReputationTypes.Reputation) -> String:
	match rep:
		TrainerReputationTypes.Reputation.BUDDY: return "Kumpeltyp"
		TrainerReputationTypes.Reputation.FUNNY_GUY: return "Lustiger Geselle"
		TrainerReputationTypes.Reputation.MOTIVATOR: return "Motivationskünstler"
		TrainerReputationTypes.Reputation.PR_MAN: return "PR-Mann"
		TrainerReputationTypes.Reputation.HARD_DRIVER: return "Schleifer"
		TrainerReputationTypes.Reputation.SCIENTIST: return "Wissenschaftler"
		_: return "–"


func _reporter_attitude(att: ReporterAttitudeTypes.Attitude) -> String:
	match att:
		ReporterAttitudeTypes.Attitude.HOSTILE: return "Böse"
		ReporterAttitudeTypes.Attitude.NEUTRAL: return "Neutral"
		ReporterAttitudeTypes.Attitude.FRIENDLY: return "Freundlich"
		_: return "–"


func _referee_char(c: RefereeCharacteristicTypes.Characteristic) -> String:
	match c:
		RefereeCharacteristicTypes.Characteristic.FAVORS_HOME_TEAM: return "Heimschiedsrichter"
		RefereeCharacteristicTypes.Characteristic.FAVORS_AWAY_TEAM: return "Gastschiedsrichter"
		RefereeCharacteristicTypes.Characteristic.HATES_COMPLAINING: return "Hasst Meckern"
		RefereeCharacteristicTypes.Characteristic.HATES_TIME_WASTING: return "Hasst Zeitspiel"
		RefereeCharacteristicTypes.Characteristic.HATES_COACHING: return "Hasst Coaching"
		_: return "–"
