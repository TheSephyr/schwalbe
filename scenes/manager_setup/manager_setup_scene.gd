extends Control

@onready var lastname_edit: LineEdit = $CenterContainer/ContentVBox/FormPanel/FormMargin/FormVBox/LastnameEdit
@onready var firstname_edit: LineEdit = $CenterContainer/ContentVBox/FormPanel/FormMargin/FormVBox/FirstnameEdit
@onready var age_spinbox: SpinBox = $CenterContainer/ContentVBox/FormPanel/FormMargin/FormVBox/AgeSpinBox
@onready var confirm_button: Button = $CenterContainer/ContentVBox/FormPanel/FormMargin/FormVBox/ConfirmButton


func _ready() -> void:
	confirm_button.disabled = true
	lastname_edit.text_changed.connect(_validate)
	firstname_edit.text_changed.connect(_validate)


func _validate(_text: String) -> void:
	confirm_button.disabled = (
		lastname_edit.text.strip_edges().is_empty()
		or firstname_edit.text.strip_edges().is_empty()
	)


func _on_confirm_pressed() -> void:
	Game.trainer_lastname = lastname_edit.text.strip_edges()
	Game.trainer_firstname = firstname_edit.text.strip_edges()
	var birth_year := GameConfig.SEASON_START_YEAR - int(age_spinbox.value)
	Game.trainer_birthdate = "01.07.%d" % birth_year
	get_tree().change_scene_to_file("res://scenes/team_selection.tscn")
