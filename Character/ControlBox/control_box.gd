class_name ControlBox extends Node

const Actions = preload("res://InputManager/actions.gd")

func movement() -> Vector2:
	return Vector2(0,0)

func aim() -> Vector2:
	return Vector2(0,0)

func is_action_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return false

func is_action_just_pressed(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return false

func is_action_just_released(action: Actions.PlayerActionButtons, cooldown = 0.0) -> bool:
	return false	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
