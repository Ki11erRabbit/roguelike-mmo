extends Node

const PlayerInput = preload("res://InputManager/InputProcessor/player_input.gd")
const MenuInput = preload("res://InputManager/InputProcessor/menu_input.gd")
const MainMenuInput = preload("res://InputManager/InputProcessor/main_menu_input.gd")

var input_state = PlayerInput.PlayerInput.new()

func get_stick_vector(stick) -> Vector2:
	return input_state.get_stick_vector(stick)
	
func is_action_pressed(action) -> bool:
	return input_state.is_action_pressed(action)

func is_action_just_pressed(action) -> bool:
	return input_state.is_action_just_pressed(action)

func is_action_just_released(action) -> bool:
	return input_state.is_action_just_released(action)
	

func open_menu():
	input_state = MenuInput.MenuInput.new()

func close_menu():
	input_state = PlayerInput.PlayerInput.new()

func start_game():
	input_state = PlayerInput.PlayerInput.new()

func open_main_menu():
	input_state = MainMenuInput.MainMenuInput.new()
