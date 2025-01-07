extends Node

const Actions = preload("res://InputManager/actions.gd")

var current_movement_vec: Vector2 = Vector2(0, 0)
var current_aim_vec: Vector2 = Vector2(0, 0)

var buttons_pressed: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var buttons_held_down: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var buttons_just_released: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var released_again: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return true)

var last_stick: Array = [null, null]

@rpc("unreliable")
func move_stick(stick: Actions.PlayerActionSticks, x: float, y: float):
	if is_multiplayer_authority():
		return
	match stick:
		Actions.PlayerActionSticks.Movement:
			current_movement_vec = Vector2(x, y)
			#rpc("move_stick", stick, x, y)
		Actions.PlayerActionSticks.Aim:
			current_aim_vec = Vector2(x, y)
			#rpc("move_stick", stick, x, y)

@rpc("unreliable")
func press_button(action: Actions.PlayerActionButtons):
	if is_multiplayer_authority():
		return
	buttons_pressed[action] = true
	buttons_just_released[action] = false
	#rpc("press_button", action)

@rpc("unreliable")
func hold_down_button(action: Actions.PlayerActionButtons):
	if is_multiplayer_authority():
		return
	buttons_pressed[action] = true
	buttons_held_down[action] = true
	buttons_just_released[action] = false
	#rpc("hold_down_button", action)

@rpc("unreliable")
func release_button(action: Actions.PlayerActionButtons):
	if is_multiplayer_authority():
		return
	buttons_pressed[action] = false
	buttons_held_down[action] = false
	buttons_just_released[action] = true
	#rpc("release_button", action)

func player_button_control():
	manage_player_button(Actions.PlayerActionButtons.RightAttack)
	manage_player_button(Actions.PlayerActionButtons.RightStrongAttack)
	manage_player_button(Actions.PlayerActionButtons.LeftAttack)
	manage_player_button(Actions.PlayerActionButtons.LeftStrongAttack)
	manage_player_button(Actions.PlayerActionButtons.Jump)
	manage_player_button(Actions.PlayerActionButtons.Parry)
	manage_player_button(Actions.PlayerActionButtons.Dash)
	manage_player_button(Actions.PlayerActionButtons.QuickAccess1)
	manage_player_button(Actions.PlayerActionButtons.QuickAccess2)
	manage_player_button(Actions.PlayerActionButtons.QuickAccess3)
	manage_player_button(Actions.PlayerActionButtons.QuickAccess4)
	manage_player_button(Actions.PlayerActionButtons.Interact)
	manage_player_button(Actions.PlayerActionButtons.Menu)
	manage_player_button(Actions.PlayerActionButtons.Map)
	manage_player_button(Actions.PlayerActionButtons.EmoteWindow)
	manage_player_button(Actions.PlayerActionButtons.QuickChat)
	
	manage_player_stick(Actions.PlayerActionSticks.Movement)
	manage_player_stick(Actions.PlayerActionSticks.Aim)
	

func manage_player_button(button) -> void:
	if InputManager.is_action_pressed(button):
		released_again[button] = false
		if buttons_pressed[button]:
			if not buttons_held_down[button]:
				buttons_held_down[button] = true
				rpc("hold_down_button", button)
		else:
			rpc("press_button", button)
	else:
		if not released_again[button]:
			released_again[button] = true
			rpc("release_button", button)

func manage_player_stick(stick) -> void:
	var stick_vec = InputManager.get_stick_vector(stick)
	
	if stick_vec == last_stick[stick]:
		return
	last_stick[stick] = stick_vec
	rpc("move_stick", stick, stick_vec.x, stick_vec.y)



func tick(delta: float) -> void:
	
	if not is_multiplayer_authority():
		# we are the server, we do not poll for button presses
		for i in range(0, buttons_just_released.size()):
			buttons_just_released[i] = false
		#print(get_multiplayer_authority())
		return
	player_button_control()

func _ready() -> void:
	InputManager.start_game()


func movement() -> Vector2:
	return current_movement_vec

func aim() -> Vector2:
	return current_aim_vec

func is_action_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	var value = buttons_pressed[action]
	return value and buttons_held_down[action]

func is_action_just_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	var value = buttons_pressed[action]
	return value and not buttons_held_down[action]

func is_action_just_released(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	var value = buttons_just_released[action]
	var released = buttons_just_released[action]
	return value and released and not buttons_held_down[action]
