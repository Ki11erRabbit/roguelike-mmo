class_name ControlBox extends Node

const Actions = preload("res://InputManager/actions.gd")

func movement() -> Vector2:
	return Vector2(0,0)

func aim() -> Vector2:
	return Vector2(0,0)

func is_action_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return false

func is_action_just_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return false

func is_action_just_released(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return false	

func tick(delta: float) -> void:
	pass
