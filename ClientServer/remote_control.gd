extends Node

const Actions = preload("res://InputManager/actions.gd")

var current_movement_vec: Vector2 = Vector2(0, 0)
var current_aim_vec: Vector2 = Vector2(0, 0)

var buttons_pressed: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var pressed_time: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return 1.0)
var released_time: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return 1.0)

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
	pressed_time[action] = 0.0
	#rpc("press_button", action)

@rpc("unreliable")
func release_button(action: Actions.PlayerActionButtons):
	if is_multiplayer_authority():
		return
	buttons_pressed[action] = false
	released_time[action] = 0.0
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
		if buttons_pressed[button] == false:
			buttons_pressed[button] = true
			rpc("press_button", button)
	else:
		if buttons_pressed[button] == true:
			buttons_pressed[button] = false
			released_time[button] = 0.0
			rpc("release_button", button)

func manage_player_stick(stick) -> void:
	var stick_vec = InputManager.get_stick_vector(stick)
	
	if last_stick[stick] != null:
		var stick_diff = last_stick[stick] - stick_vec
		stick_diff.x = abs(stick_diff.x)
		stick_diff.y = abs(stick_diff.y)
		if stick_diff.x < 0.0001 and stick_diff.y < 0.0001:
			return
	last_stick[stick] = stick_vec
	rpc("move_stick", stick, stick_vec.x, stick_vec.y)



func tick(delta: float) -> void:
	if not is_multiplayer_authority():
		# we are the server, we do not poll for button presses
		for i in range(0, buttons_pressed.size()):
			if buttons_pressed[i]:
				pressed_time[i] += delta
			elif not buttons_pressed[i]:
				released_time[i] += delta
		#print(get_multiplayer_authority())
		return
	player_button_control()

func _ready() -> void:
	if not is_multiplayer_authority():
		InputManager.start_game()


func movement() -> Vector2:
	return current_movement_vec

func aim() -> Vector2:
	return current_aim_vec

func is_action_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	var value = buttons_pressed[action]
	return value

func is_action_just_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	var value = buttons_pressed[action]
	return value and pressed_time[action] <= 0.1

func is_action_just_released(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	var value = buttons_pressed[action]
	#print(released_time[action])
	if released_time[action] <= 0.1:
		print("just released")
	else:
		print("not just released")
	return not value and released_time[action] <= 0.1
