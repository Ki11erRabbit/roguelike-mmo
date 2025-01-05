class_name RemoteControlBox extends "res://Character/ControlBox/control_box.gd"

@onready
var remote_control = $RemoteControl

func set_multiplayer_auth(id):
	set_multiplayer_authority(id)

func movement() -> Vector2:
	return remote_control.current_movement_vec

func aim() -> Vector2:
	return remote_control.current_aim_vec

func is_action_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return remote_control.is_action_pressed(action, cooldown)

func is_action_just_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return remote_control.is_action_just_pressed(action, cooldown)

func is_action_just_released(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return remote_control.is_action_just_released(action, cooldown)

func tick(delta: float) -> void:
	for i in range(0, remote_control.buttons_just_released.size()):
		remote_control.buttons_just_released[i] = false
