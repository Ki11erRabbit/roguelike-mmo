class_name RemoteControlBox extends "res://Character/ControlBox/control_box.gd"

@onready
var remote_control = $RemoteControl


func movement() -> Vector2:
	if not is_multiplayer_authority():
		# We are the server
		return remote_control.current_movement_vec
	return InputManager.get_stick_vector(Actions.PlayerActionSticks.Movement)

func aim() -> Vector2:
	if not is_multiplayer_authority():
		# We are the server
		return remote_control.current_aim_vec
	return InputManager.get_stick_vector(Actions.PlayerActionSticks.Aim)

func is_action_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	if not is_multiplayer_authority():
		# We are the server
		return remote_control.is_action_pressed(action, cooldown)
	return InputManager.is_action_pressed(action, cooldown)

func is_action_just_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	if not is_multiplayer_authority():
		# We are the server
		return remote_control.is_action_just_pressed(action, cooldown)
	return InputManager.is_action_just_pressed(action, cooldown)

func is_action_just_released(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	if not is_multiplayer_authority():
		# We are the server
		return remote_control.is_action_just_released(action, cooldown)
	return InputManager.is_action_just_released(action, cooldown)

func tick(delta: float) -> void:
	remote_control.tick(delta)
	pass
