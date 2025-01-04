class_name AIControlBox extends "res://Character/ControlBox/control_box.gd"

var current_movement_vec: Vector2 = Vector2(0, 0)
var current_aim_vec: Vector2 = Vector2(0, 0)

var buttons_pressed: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var buttons_held_down: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var buttons_just_released: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)

func press_button(action: Actions.PlayerActionButtons):
	buttons_pressed[action] = true
	buttons_just_released[action] = false

func hold_down_button(action: Actions.PlayerActionButtons):
	buttons_pressed[action] = true
	buttons_held_down[action] = true
	buttons_just_released[action] = false

func release_button(action: Actions.PlayerActionButtons):
	buttons_pressed[action] = false
	buttons_held_down[action] = false
	buttons_just_released[action] = true

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
	buttons_just_released[action] = false
	return value and not buttons_held_down[action]
