extends StaticBody2D

@onready var nameLabel: Label = $NameLabel
@onready var strengthLabel: Label = $StrengthLabel
var dragging: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setPlayer(player: Player) -> void:
	nameLabel.text = player.lastname
	strengthLabel.text = player.currentAbility


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event.is_released():
		pass
	if event.is_pressed():
		pass
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		position = event.position
	pass # Replace with function body.
	
