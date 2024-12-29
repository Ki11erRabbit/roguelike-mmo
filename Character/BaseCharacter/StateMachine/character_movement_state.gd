class_name CharacterMovementState extends Node

const Actions = preload("res://InputManager/actions.gd")
var character: Player

var last_aim: Vector2
var initalized: bool = false
const X_ROTATION_AMOUNT: float = -15
# Determines the angle that allows for playing the rotation animation
const ROTATION_ANGLE_LIMIT: float = 10

const SPEED = 0.5

const JUMP_VELOCITY = 20

var disable_gravity: bool = false

func initialize(character: Player, current_last_aim: Vector2, additional = null):
	last_aim = current_last_aim
	initalized = true
	self.character = character
	

func apply_current_state(delta: float):
	pass

func process_rotation() -> Array[bool]:
	"""
	Returns: An array that contains 2 elements, the first is if there is rotation, the second if the rotation is clockwise
	"""
	assert(initalized, "Initialize was not called, crashing")
	
	var aim_direction = InputManager.get_stick_vector(Actions.PlayerActionSticks.Aim)
	var normalized_aim = aim_direction.normalized()
	
	var rotating: bool = false
	var clockwise_rotation: bool = is_rotating_clockwise(aim_direction.angle(), last_aim.angle())
	var aim_direction_was_zero: bool = (aim_direction.x == 0 and aim_direction.y == 0)
	
	
	if aim_direction.x == 0 and aim_direction.y == 0:
		aim_direction = last_aim
		normalized_aim = last_aim.normalized()
	
	#current_aim_angle = lerp_angle(last_aim_angle, current_aim_angle, 0.1)
	character.model.rotation.x = 0
	character.hitbox.rotation.x = 0
	character.model.rotation.z = 0
	character.hitbox.rotation.z = 0
	character.model.rotation.y = atan2(aim_direction.x, aim_direction.y)
	character.hitbox.rotation.y = character.model.rotation.y
	character.hitbox.rotate_x(deg_to_rad(X_ROTATION_AMOUNT))
	character.model.rotate_x(deg_to_rad(X_ROTATION_AMOUNT))
	
	if (not aim_direction_was_zero) and rad_to_deg(abs(aim_direction.angle() - last_aim.angle())) < ROTATION_ANGLE_LIMIT:
		rotating = true
	last_aim = aim_direction
	
	return [rotating, clockwise_rotation]

func process_movement_buttons(current_state: CharacterMovementState) -> bool:
	"""This includes actions like jump and dash
	returns: The bool indicates whether or not the caller should stop their code from executing
	"""
	assert(initalized, "Initialize was not called, crashing")
	if InputManager.is_action_just_released(Actions.PlayerActionButtons.Jump) and character.is_on_floor():
		current_state.jump()
		return true
	elif InputManager.is_action_pressed(Actions.PlayerActionButtons.Jump):
		pass
	return false

func process_movement(current_state: CharacterMovementState = null):
	var movement_stick: Vector2 = InputManager.get_stick_vector(Actions.PlayerActionSticks.Movement)
	if movement_stick.x != 0 or movement_stick.y != 0:
		if current_state != null:
			current_state.custom_movement()
		else:
			movement_stick = movement_stick * SPEED
			character.velocity.x = movement_stick.x
			character.velocity.z = movement_stick.y

func custom_movement():
	pass

func process_gravity(delta: float, current_state: CharacterMovementState):
	if disable_gravity:
		return
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta
		current_state.in_air(delta)
	elif character.is_on_floor():
		current_state.on_ground(delta)

func in_air(delta: float):
	pass
func on_ground(delta: float):
	pass

func stand():
	pass
	
func move():
	pass

func jump():
	character.movement_state = JumpState.new()
	character.movement_state.initialize(character, last_aim)

func jumping():
	pass

func falling():
	pass

func landing():
	pass

func is_rotating_clockwise(current, last) -> bool:
	current = rad_to_deg(current)
	last = rad_to_deg(last)
	
	if last > 0:
		if current > last:
			return false
		else:
			return true
	elif last < 0:
		if current > last:
			return false
		else:
			return true
	else:
		return false
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
