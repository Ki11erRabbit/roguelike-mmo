class PlayerInput extends "res://InputManager/InputProcessor/input_processor.gd":
	
	const Actions = preload("res://InputManager/actions.gd")
	func get_stick_vector(stick) -> Vector2:
		match stick:
			Actions.PlayerActionSticks.Movement:
				return InputMapper.get_stick_vector("player_movement")
			Actions.PlayerActionSticks.Aim:
				return InputMapper.get_stick_vector("player_aim")
			_:
				assert(false, "Unrecognized stick for PlayerInput State {0}".format([stick]))
			
				
		return Vector2(0,0)

	func is_action_pressed(action) -> bool:
		match action:
			Actions.PlayerActionButtons.RightAttack:
				return InputMapper.is_action_pressed("player_right_attack")
			Actions.PlayerActionButtons.RightStrongAttack:
				return InputMapper.is_action_pressed("player_right_strong_attack")
			Actions.PlayerActionButtons.LeftAttack:
				return InputMapper.is_action_pressed("player_left_attack")
			Actions.PlayerActionButtons.LeftStrongAttack:
				return InputMapper.is_action_pressed("player_left_strong_attack")
			Actions.PlayerActionButtons.Jump:
				return InputMapper.is_action_pressed("player_jump")
			Actions.PlayerActionButtons.Parry:
				return InputMapper.is_action_pressed("player_parry")
			Actions.PlayerActionButtons.Dash:
				return InputMapper.is_action_pressed("player_dash")
			Actions.PlayerActionButtons.QuickAccess1:
				return InputMapper.is_action_pressed("player_quick_access1")
			Actions.PlayerActionButtons.QuickAccess2:
				return InputMapper.is_action_pressed("player_quick_access2")
			Actions.PlayerActionButtons.QuickAccess3:
				return InputMapper.is_action_pressed("player_quick_access3")
			Actions.PlayerActionButtons.QuickAccess4:
				return InputMapper.is_action_pressed("player_quick_access4")
			Actions.PlayerActionButtons.Interact:
				return InputMapper.is_action_pressed("player_interact")
			Actions.PlayerActionButtons.Menu:
				return InputMapper.is_action_pressed("player_menu")
			Actions.PlayerActionButtons.Map:
				return InputMapper.is_action_pressed("player_map")
			Actions.PlayerActionButtons.EmoteWindow:
				return InputMapper.is_action_pressed("player_emote_window")
			Actions.PlayerActionButtons.QuickChat:
				return InputMapper.is_action_pressed("player_quick_chat")
			_:
				assert(false, "Unrecognized button for PlayerInput State {0}".format([action]))
				return false
			

	func is_action_just_pressed(action) -> bool:
		match action:
			Actions.PlayerActionButtons.RightAttack:
				return InputMapper.is_action_just_pressed("player_right_attack")
			Actions.PlayerActionButtons.RightStrongAttack:
				return InputMapper.is_action_just_pressed("player_right_strong_attack")
			Actions.PlayerActionButtons.LeftAttack:
				return InputMapper.is_action_just_pressed("player_left_attack")
			Actions.PlayerActionButtons.LeftStrongAttack:
				return InputMapper.is_action_just_pressed("player_left_strong_attack")
			Actions.PlayerActionButtons.Jump:
				return InputMapper.is_action_just_pressed("player_jump")
			Actions.PlayerActionButtons.Parry:
				return InputMapper.is_action_just_pressed("player_parry")
			Actions.PlayerActionButtons.Dash:
				return InputMapper.is_action_just_pressed("player_dash")
			Actions.PlayerActionButtons.QuickAccess1:
				return InputMapper.is_action_just_pressed("player_quick_access1")
			Actions.PlayerActionButtons.QuickAccess2:
				return InputMapper.is_action_just_pressed("player_quick_access2")
			Actions.PlayerActionButtons.QuickAccess3:
				return InputMapper.is_action_just_pressed("player_quick_access3")
			Actions.PlayerActionButtons.QuickAccess4:
				return InputMapper.is_action_just_pressed("player_quick_access4")
			Actions.PlayerActionButtons.Interact:
				return InputMapper.is_action_just_pressed("player_interact")
			Actions.PlayerActionButtons.Menu:
				return InputMapper.is_action_just_pressed("player_menu")
			Actions.PlayerActionButtons.Map:
				return InputMapper.is_action_just_pressed("player_map")
			Actions.PlayerActionButtons.EmoteWindow:
				return InputMapper.is_action_just_pressed("player_emote_window")
			Actions.PlayerActionButtons.QuickChat:
				return InputMapper.is_action_just_pressed("player_quick_chat")
			_:
				assert(false, "Unrecognized button for PlayerInput State {0}".format([action]))
				return false

	func is_action_just_released(action) -> bool:
		match action:
			Actions.PlayerActionButtons.RightAttack:
				return InputMapper.is_action_just_released("player_right_attack")
			Actions.PlayerActionButtons.RightStrongAttack:
				return InputMapper.is_action_just_released("player_right_strong_attack")
			Actions.PlayerActionButtons.LeftAttack:
				return InputMapper.is_action_just_released("player_left_attack")
			Actions.PlayerActionButtons.LeftStrongAttack:
				return InputMapper.is_action_just_released("player_left_strong_attack")
			Actions.PlayerActionButtons.Jump:
				return InputMapper.is_action_just_released("player_jump")
			Actions.PlayerActionButtons.Parry:
				return InputMapper.is_action_just_released("player_parry")
			Actions.PlayerActionButtons.Dash:
				return InputMapper.is_action_just_released("player_dash")
			Actions.PlayerActionButtons.QuickAccess1:
				return InputMapper.is_action_just_released("player_quick_access1")
			Actions.PlayerActionButtons.QuickAccess2:
				return InputMapper.is_action_just_released("player_quick_access2")
			Actions.PlayerActionButtons.QuickAccess3:
				return InputMapper.is_action_just_released("player_quick_access3")
			Actions.PlayerActionButtons.QuickAccess4:
				return InputMapper.is_action_just_released("player_quick_access4")
			Actions.PlayerActionButtons.Interact:
				return InputMapper.is_action_just_released("player_interact")
			Actions.PlayerActionButtons.Menu:
				return InputMapper.is_action_just_released("player_menu")
			Actions.PlayerActionButtons.Map:
				return InputMapper.is_action_just_released("player_map")
			Actions.PlayerActionButtons.EmoteWindow:
				return InputMapper.is_action_just_released("player_emote_window")
			Actions.PlayerActionButtons.QuickChat:
				return InputMapper.is_action_just_released("player_quick_chat")
			_:
				assert(false, "Unrecognized button for PlayerInput State {0}".format([action]))
				return false
