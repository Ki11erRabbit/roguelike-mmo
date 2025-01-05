extends Node

const Actions = preload("res://InputManager/actions.gd")
@onready
var remote_control_box: RemoteControlBox = $RemoteControlBox

var buttons_pressed: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)
var buttons_held_down: Array = range(0, Actions.PlayerActionButtons.QuickChat + 1).map(func(x): return false)

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
	

func manage_player_button(button) -> void:
	if InputManager.is_action_pressed(button):
		if buttons_pressed[button]:
			if not buttons_held_down[button]:
				buttons_held_down[button] = true
				remote_control_box.rpc("hold_down_button", button)
		else:
			remote_control_box.rpc("press_button", button)
	else:
		remote_control_box.rpc("release_button", button)

func manage_player_stick(stick) -> void:
	var stick_vec = InputManager.get_stick_vector(stick)
	remote_control_box.rpc("move_stick", stick, stick_vec.x, stick_vec.y)

func _physics_process(delta: float) -> void:
	player_button_control()

func _ready() -> void:
	InputManager.start_game()
