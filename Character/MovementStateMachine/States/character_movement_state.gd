class_name CharacterMovementState extends Node

const Actions = preload("res://InputManager/actions.gd")
var character: Character

var state_machine: MovementStateMachine
var initalized: bool = false


func initialize(character: Character, state_machine: MovementStateMachine, additional = null):
	self.state_machine = state_machine
	initalized = true
	self.character = character
	

func apply_current_state(delta: float, control_box: ControlBox, rotation_triple: Array):
	pass
## Returns: An array that contains 3 elements, the first is if there is rotation, the second if the rotation is clockwise
## and the third is a vector2 of the current aim
func process_rotation(delta: float, control_box: ControlBox, last_aim: Vector2) -> Array:
	if control_box == null:
		return [false, false, state_machine.last_aim]
	
	var aim_direction = control_box.aim()
	var normalized_aim = aim_direction.normalized()
	
	
	var rotating: bool = false
	var clockwise_rotation: bool = is_rotating_clockwise(aim_direction.angle(), last_aim.angle())
	var aim_direction_was_zero: bool = (aim_direction.x == 0 and aim_direction.y == 0)
	
	
	if aim_direction.x == 0 and aim_direction.y == 0:
		aim_direction = last_aim
		normalized_aim = last_aim.normalized()
	#print(last_aim)
	
	character.model.rotation.x = 0
	character.collision_box.rotation.x = 0
	character.model.rotation.z = 0
	character.collision_box.rotation.z = 0
	character.model.rotation.y = atan2(aim_direction.x, aim_direction.y)
	character.collision_box.rotation.y = character.model.rotation.y
	character.collision_box.rotate_x(deg_to_rad(state_machine.X_ROTATION_AMOUNT))
	character.model.rotate_x(deg_to_rad(state_machine.X_ROTATION_AMOUNT))
	
	
	if (not aim_direction_was_zero) and rad_to_deg(abs(aim_direction.angle() - last_aim.angle())) < state_machine.ROTATION_ANGLE_LIMIT:
		rotating = true
	last_aim = aim_direction
	#print(last_aim)
	#print("")
	
	return [rotating, clockwise_rotation, aim_direction]

## This includes actions like jump and dash
## returns: The bool indicates whether or not the caller should stop their code from executing
func process_movement_buttons(delta: float, control_box: ControlBox, current_state: CharacterMovementState) -> bool:
	if control_box == null:
		return false
	if control_box.is_action_just_released(Actions.PlayerActionButtons.Jump) and character.is_on_floor():
		if character.is_jumping():
			return false
		current_state.jump()
		return true
	elif control_box.is_action_pressed(Actions.PlayerActionButtons.Jump):
		pass
	return false

func process_movement(delta: float, control_box: ControlBox, current_state: CharacterMovementState = null):
	if control_box == null:
		return
	var movement_stick: Vector2 = control_box.movement()
	if movement_stick.x != 0 or movement_stick.y != 0:
		if current_state.use_custom_movement():
			current_state.custom_movement(control_box)
		else:
			movement_stick = movement_stick * state_machine.SPEED
			character.velocity.x = movement_stick.x
			character.velocity.z = movement_stick.y

func use_custom_movement() -> bool:
	return false

func custom_movement(control_box: ControlBox):
	pass

func process_gravity(delta: float, current_state: CharacterMovementState):
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
	print("jumping")
	state_machine.movement_state = JumpState.new()
	state_machine.movement_state.initialize(character, state_machine)
	character.jump()

func jumping():
	pass

func falling():
	pass

func landing():
	pass

func clockwise_spin():
	var old_state: CharacterMovementState = state_machine.movement_state
	state_machine.movement_state = ClockwiseSpin.new()
	state_machine.movement_state.initialize(character, state_machine, old_state)

func counter_clockwise_spin():
	var old_state: CharacterMovementState = state_machine.movement_state
	state_machine.movement_state = CounterClockwiseSpin.new()
	state_machine.movement_state.initialize(character, state_machine, old_state)

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
