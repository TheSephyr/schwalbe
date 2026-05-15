extends PanelContainer

@export var training_type: int = 0

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := Label.new()
	preview.text = _type_label()
	set_drag_preview(preview)
	return {"training_type": training_type}

func _type_label() -> String:
	match training_type:
		GameConfig.TRAINING_TYPE_CONDITION:
			return "Konditionstraining"
		GameConfig.TRAINING_TYPE_REGEN:
			return "Regeneration"
	return ""
