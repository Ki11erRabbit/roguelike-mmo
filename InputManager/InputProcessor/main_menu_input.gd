class MainMenuInput extends "res://InputManager/InputProcessor/input_processor.gd":

	const Actions = preload("res://InputManager/actions.gd")
	
	func get_stick_vector(stick) -> Vector2:
		assert(false, "There are no stick actions for MainMenuInput")
		return Vector2(0,0)
	
	func is_action_pressed(action) -> bool:
		match action:
			Actions.MainMenuActionButtons.Accept:
				return InputMapper.is_action_pressed("main_menu_accept")
			Actions.MainMenuActionButtons.Reject:
				return InputMapper.is_action_pressed("main_menu_reject")
			Actions.MainMenuActionButtons.Up:
				return InputMapper.is_action_pressed("main_menu_up")
			Actions.MainMenuActionButtons.Down:
				return InputMapper.is_action_pressed("main_menu_down")
			Actions.MainMenuActionButtons.Left:
				return InputMapper.is_action_pressed("main_menu_left")
			Actions.MainMenuActionButtons.Right:
				return InputMapper.is_action_pressed("main_menu_right")
			_:
				assert(false, "Invalid button for MainMenuInput {0}".format([action]))
				return false
	
	func is_action_just_pressed(action) -> bool:
		match action:
			Actions.MainMenuActionButtons.Accept:
				return InputMapper.is_action_just_pressed("main_menu_accept")
			Actions.MainMenuActionButtons.Reject:
				return InputMapper.is_action_just_pressed("main_menu_reject")
			Actions.MainMenuActionButtons.Up:
				return InputMapper.is_action_just_pressed("main_menu_up")
			Actions.MainMenuActionButtons.Down:
				return InputMapper.is_action_just_pressed("main_menu_down")
			Actions.MainMenuActionButtons.Left:
				return InputMapper.is_action_just_pressed("main_menu_left")
			Actions.MainMenuActionButtons.Right:
				return InputMapper.is_action_just_pressed("main_menu_right")
			_:
				assert(false, "Invalid button for MainMenuInput {0}".format([action]))
				return false
	
	func is_action_just_released(action) -> bool:
		match action:
			Actions.MainMenuActionButtons.Accept:
				return InputMapper.is_action_just_pressed("main_menu_accept")
			Actions.MainMenuActionButtons.Reject:
				return InputMapper.is_action_just_released("main_menu_reject")
			Actions.MainMenuActionButtons.Up:
				return InputMapper.is_action_just_released("main_menu_up")
			Actions.MainMenuActionButtons.Down:
				return InputMapper.is_action_just_released("main_menu_down")
			Actions.MainMenuActionButtons.Left:
				return InputMapper.is_action_just_released("main_menu_left")
			Actions.MainMenuActionButtons.Right:
				return InputMapper.is_action_just_released("main_menu_right")
			_:
				assert(false, "Invalid button for MainMenuInput {0}".format([action]))
				return false
