extends Node

const PlayerInput = preload("res://InputManager/InputProcessor/player_input.gd")
const MenuInput = preload("res://InputManager/InputProcessor/menu_input.gd")
const MainMenuInput = preload("res://InputManager/InputProcessor/main_menu_input.gd")

var input_disabled: bool = false
var cool_down: Dictionary = {}

var input_state = MainMenuInput.MainMenuInput.new()

func get_stick_vector(stick, cooldown = 0.0) -> Vector2:
	if stick not in cool_down:
		cool_down[stick] = 0
	if not input_disabled and cool_down[stick] <= 0.0:
		var result = input_state.get_stick_vector(stick)
		if result.x != 0 and result.y != 0:
			cool_down[stick] = cooldown
		return result
	return Vector2(0,0)
	
func is_action_pressed(action, cooldown = 0.0) -> bool:
	if action not in cool_down:
		cool_down[action] = 0
	if not input_disabled and cool_down[action] <= 0.0:
		var result = input_state.is_action_pressed(action)
		if result:
			cool_down[action] = cooldown
		return result
	return false

func is_action_just_pressed(action, cooldown = 0.0) -> bool:
	if action not in cool_down:
		cool_down[action] = 0
	if not input_disabled and cool_down[action] <= 0.0:
		var result = input_state.is_action_just_pressed(action)
		if result:
			cool_down[action] = cooldown
		return result
	return false

func is_action_just_released(action, cooldown = 0.0) -> bool:
	if action not in cool_down:
		cool_down[action] = 0
	if not input_disabled and cool_down[action] <= 0.0:
		var result = input_state.is_action_just_released(action)
		if result:
			cool_down[action] = cooldown
		return result
	return false
	

func open_menu():
	input_state = MenuInput.MenuInput.new()

func close_menu():
	input_state = PlayerInput.PlayerInput.new()

func start_game():
	input_state = PlayerInput.PlayerInput.new()

func open_main_menu():
	input_state = MainMenuInput.MainMenuInput.new()

func enable_input():
	input_disabled = false

func disable_input():
	input_disabled = true

func _process(delta: float) -> void:
	for key in cool_down.keys():
		cool_down[key] -= delta
