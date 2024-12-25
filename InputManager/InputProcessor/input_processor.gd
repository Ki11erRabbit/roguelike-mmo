class InputProcessor extends Node:

	func get_stick_vector(stick) -> Vector2:
		return Vector2(0,0)
	
	func is_action_pressed(action) -> bool:
		return false
	
	func is_action_just_pressed(action) -> bool:
		return false
	
	func is_action_just_released(action) -> bool:
		return false
