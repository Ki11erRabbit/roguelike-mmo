extends Control

const Actions = preload("res://InputManager/actions.gd")

const COOLDOWN = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if InputManager.is_action_pressed(Actions.MainMenuActionButtons.Up, COOLDOWN):
		pass
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Down, COOLDOWN):
		pass
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Accept, COOLDOWN):
		pass
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Reject, COOLDOWN):
		pass
