extends Node

const PlayerInput = preload("res://InputManager/InputProcessor/player_input.gd")

var input_state = PlayerInput.PlayerInput.new()

func get_stick_vector(stick) -> Vector2:
	return input_state.get_stick_vector(stick)
	
func is_action_pressed(action) -> bool:
	return input_state.is_action_pressed(action)

func is_action_just_pressed(action) -> bool:
	return input_state.is_action_just_pressed(action)

func is_action_just_released(action) -> bool:
	return input_state.is_action_just_released(action)
