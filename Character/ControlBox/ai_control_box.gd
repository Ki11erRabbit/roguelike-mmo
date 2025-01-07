class_name AIControlBox extends "res://Character/ControlBox/control_box.gd"

var current_movement_vec: Vector2 = Vector2(0, 0)
var current_aim_vec: Vector2 = Vector2(0, 0)

var buttons_pressed: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var buttons_held_down: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var buttons_just_released: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)

@rpc("unreliable", "call_remote")
func rpc_move_stick(stick: Actions.PlayerActionSticks, x: float, y: float):
	match stick:
		Actions.PlayerActionSticks.Movement:
			current_movement_vec = Vector2(x, y)
		Actions.PlayerActionSticks.Aim:
			current_aim_vec = Vector2(x, y)

@rpc("unreliable", "call_remote")
func rpc_press_button(action: Actions.PlayerActionButtons):
	press_button(action)

@rpc("unreliable", "call_remote")
func rpc_hold_down_button(action: Actions.PlayerActionButtons):
	hold_down_button(action)

@rpc("unreliable", "call_remote")
func rpc_release_button(action: Actions.PlayerActionButtons):
	release_button(action)

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
	buttons_just_released[action] = false
	if rpc:	
		rpc("rpc_press_button", action)

func hold_down_button(action: Actions.PlayerActionButtons, rpc: bool = false):
	buttons_pressed[action] = true
	buttons_held_down[action] = true
	buttons_just_released[action] = false
	if rpc:	
		rpc("hold_down_button", action)

func release_button(action: Actions.PlayerActionButtons, rpc: bool = false):
	buttons_pressed[action] = false
	buttons_held_down[action] = false
	buttons_just_released[action] = true
	if rpc:	
		rpc("release_button", action)

@rpc
func reset_buttons(rpc: bool = false):
	for i in range(0, buttons_just_released.size()):
		buttons_pressed[i] = false
		buttons_held_down[i] = false
		buttons_just_released[i] = false
	
	if rpc:
		rpc("reset_buttons", false)

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


func tick(delta: float) -> void:
	for i in range(0, buttons_just_released.size()):
		buttons_just_released[i] = false
