class_name PLayerControlBox extends "res://Character/ControlBox/control_box.gd"

func movement() -> Vector2:
	return InputManager.get_stick_vector(Actions.PlayerActionSticks.Movement)

func aim() -> Vector2:
	return InputManager.get_stick_vector(Actions.PlayerActionSticks.Aim)

func is_action_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return InputManager.is_action_pressed(action, cooldown)

func is_action_just_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return InputManager.is_action_just_pressed(action, cooldown)

func is_action_just_released(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return InputManager.is_action_just_released(action, cooldown)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
