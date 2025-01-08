class_name AIControlBox extends "res://Character/ControlBox/control_box.gd"

var current_movement_vec: Vector2 = Vector2(0, 0)
var current_aim_vec: Vector2 = Vector2(0, 0)


var buttons_pressed: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var pressed_time: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return 1.0)
var released_time: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return 1.0)

var last_stick: Array = [null, null]

@rpc("unreliable")
func rpc_move_stick(stick: Actions.PlayerActionSticks, x: float, y: float):
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
func rpc_press_button(action: Actions.PlayerActionButtons):
	if is_multiplayer_authority():
		return
	press_button(action)
	#rpc("press_button", action)

@rpc("unreliable")
func rpc_release_button(action: Actions.PlayerActionButtons):
	if is_multiplayer_authority():
		return
	release_button(action)
	#rpc("release_button", action)

func set_movement_stick(value: Vector2, rpc: bool = false):
	if rpc:	
		rpc("rpc_move_stick", Actions.PlayerActionSticks.Movement, value.x, value.y)
	current_movement_vec = value

func set_aim_stick(value: Vector2, rpc: bool = false):
	if rpc:	
		rpc("rpc_move_stick", Actions.PlayerActionSticks.Aim, value.x, value.y)
	current_aim_vec = value

func press_button(action: Actions.PlayerActionButtons, rpc: bool = false):
	buttons_pressed[action] = true
	pressed_time[action] = 0.0
	if rpc:	
		rpc("rpc_press_button", action)

func release_button(action: Actions.PlayerActionButtons, rpc: bool = false):
	buttons_pressed[action] = false
	released_time[action] = 0.0
	if rpc:
		rpc("rpc_release_button", action)

@rpc
func reset_buttons(rpc: bool = false):
	for i in range(0, buttons_pressed.size()):
		buttons_pressed[i] = false
	
	if rpc:
		rpc("reset_buttons", false)

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
	return not value and released_time[action] <= 0.1


func tick(delta: float) -> void:
	for i in range(0, buttons_pressed.size()):
		if buttons_pressed[i]:
			pressed_time[i] += delta
		elif not buttons_pressed[i]:
			released_time[i] += delta
