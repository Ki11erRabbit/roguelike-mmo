class MenuInput extends "res://InputManager/InputProcessor/input_processor.gd":

	const Actions = preload("res://InputManager/actions.gd")
	
	func get_stick_vector(stick) -> Vector2:
		assert(false, "There are no stick actions for MenuInput")
		return Vector2(0,0)
	
	func is_action_pressed(action) -> bool:
		match action:
			Actions.MenuActionButtons.Accept:
				return InputManager.is_action_pressed("menu_accept")
			Actions.MenuActionButtons.Reject:
				return InputManager.is_action_pressed("menu_reject")
			Actions.MenuActionButtons.Up:
				return InputManager.is_action_pressed("menu_up")
			Actions.MenuActionButtons.Down:
				return InputManager.is_action_pressed("menu_down")
			Actions.MenuActionButtons.Left:
				return InputManager.is_action_pressed("menu_left")
			Actions.MenuActionButtons.Right:
				return InputManager.is_action_pressed("menu_right")
			Actions.MenuActionButtons.Search:
				return InputManager.is_action_pressed("menu_search")
			Actions.MenuActionButtons.ContextMenu:
				return InputManager.is_action_pressed("menu_context_menu")
			Actions.MenuActionButtons.Menu:
				return InputManager.is_action_pressed("menu_menu")
			Actions.MenuActionButtons.Map:
				return InputManager.is_action_pressed("menu_map")
			_:
				assert(false, "Invalid button for MenuInput {0}".format([action]))
				return false
	
	func is_action_just_pressed(action) -> bool:
		match action:
			Actions.MenuActionButtons.Accept:
				return InputManager.is_action_just_pressed("menu_accept")
			Actions.MenuActionButtons.Reject:
				return InputManager.is_action_just_pressed("menu_reject")
			Actions.MenuActionButtons.Up:
				return InputManager.is_action_just_pressed("menu_up")
			Actions.MenuActionButtons.Down:
				return InputManager.is_action_just_pressed("menu_down")
			Actions.MenuActionButtons.Left:
				return InputManager.is_action_just_pressed("menu_left")
			Actions.MenuActionButtons.Right:
				return InputManager.is_action_just_pressed("menu_right")
			Actions.MenuActionButtons.Search:
				return InputManager.is_action_just_pressed("menu_search")
			Actions.MenuActionButtons.ContextMenu:
				return InputManager.is_action_just_pressed("menu_context_menu")
			Actions.MenuActionButtons.Menu:
				return InputManager.is_action_just_pressed("menu_menu")
			Actions.MenuActionButtons.Map:
				return InputManager.is_action_just_pressed("menu_map")
			_:
				assert(false, "Invalid button for MenuInput {0}".format([action]))
				return false
	
	func is_action_just_released(action) -> bool:
		match action:
			Actions.MenuActionButtons.Accept:
				return InputManager.is_action_just_pressed("menu_accept")
			Actions.MenuActionButtons.Reject:
				return InputManager.is_action_just_released("menu_reject")
			Actions.MenuActionButtons.Up:
				return InputManager.is_action_just_released("menu_up")
			Actions.MenuActionButtons.Down:
				return InputManager.is_action_just_released("menu_down")
			Actions.MenuActionButtons.Left:
				return InputManager.is_action_just_released("menu_left")
			Actions.MenuActionButtons.Right:
				return InputManager.is_action_just_released("menu_right")
			Actions.MenuActionButtons.Search:
				return InputManager.is_action_just_released("menu_search")
			Actions.MenuActionButtons.ContextMenu:
				return InputManager.is_action_just_released("menu_context_menu")
			Actions.MenuActionButtons.Menu:
				return InputManager.is_action_just_released("menu_menu")
			Actions.MenuActionButtons.Map:
				return InputManager.is_action_just_released("menu_map")
			_:
				assert(false, "Invalid button for MenuInput {0}".format([action]))
				return false
