class_name MovingState extends "res://Character/MovementStateMachine/character_movement_state.gd"



enum MovingStates { None, Walking, Running, BackStepping, Strafing }

var current_moving_state = MovingStates.None
const DIRECTION_RESTRICT = 0.9
const LOOK_RESTRICT = 0.8

func initialize(character: Character, current_last_aim: Vector2, additional = null):
	super(character, current_last_aim)
	character.play_body_animation("walk")

func apply_current_state(delta: float):
	process_rotation()
	if process_movement_buttons(self):
		return
		
	process_gravity(delta, self)
	
	process_movement(self)
	
	var move_direction =  character.control_box.movement()
	var normalized_move = move_direction.normalized()
	var aim_direction =  character.control_box.aim()
	var normalized_aim = aim_direction.normalized()
	
	var new_movement_state: MovingStates = current_moving_state
	
	var movement_vec = move_direction * 100
	#print(movement_vec)
	
	if (movement_vec.y > 50 or movement_vec.y < -50) or (movement_vec.x > 50 or movement_vec.x < -50):
		new_movement_state = MovingStates.Running
	elif movement_vec.x != 0 or movement_vec.y != 0:
		new_movement_state = MovingStates.Walking
		
	
	# Moving Downwards
	if Vector2.DOWN.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Down")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			new_movement_state = MovingStates.BackStepping
	# Moving Upwards
	elif Vector2.UP.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Up")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			new_movement_state = MovingStates.BackStepping
	# Moving to the Right
	elif Vector2.RIGHT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			new_movement_state = MovingStates.BackStepping
	# Moving to the Left
	elif Vector2.LEFT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			new_movement_state = MovingStates.BackStepping
	# Moving to the Top Right
	elif Vector2.RIGHT.rotated(deg_to_rad(-45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Top Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			new_movement_state = MovingStates.BackStepping
	# Moving to the Bottom Right
	elif Vector2.RIGHT.rotated(deg_to_rad(45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Bottom Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			new_movement_state = MovingStates.BackStepping
	# Moving to the Top Left
	elif Vector2.LEFT.rotated(deg_to_rad(45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Top Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			new_movement_state = MovingStates.BackStepping
	# Moving to the Bottom Left
	elif Vector2.LEFT.rotated(deg_to_rad(-45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Bottom Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			new_movement_state = MovingStates.BackStepping
	else:
		new_movement_state = MovingStates.None
	
	
	if current_moving_state != new_movement_state:
		current_moving_state = new_movement_state
		match current_moving_state:
			MovingStates.Walking:
				character.model.play_body_animation("walk")
			MovingStates.Running:
				character.model.play_body_animation("run")
			MovingStates.BackStepping:
				character.model.play_body_animation("backstep")
			MovingStates.Strafing:
				pass
			MovingStates.None:
				stand()

func stand():
	character.movement_state = StandingState.new()
	character.movement_state.initialize(character, last_aim)


func custom_movement():
	var movement_stick: Vector2 =  character.control_box.movement()
	if current_moving_state == MovingStates.BackStepping or current_moving_state == MovingStates.Strafing:
		var normalized_stick: Vector2 = movement_stick.normalized()
		if normalized_stick.x <= 0.5 and normalized_stick.y <= 0.5:
			character.velocity.x = movement_stick.x * SPEED
			character.velocity.z = movement_stick.y * SPEED
		else:
			# TODO: Change so that we can
			movement_stick = movement_stick / 2
			character.velocity.x = movement_stick.x * SPEED
			character.velocity.z = movement_stick.y * SPEED
	else:
		movement_stick = movement_stick * SPEED
		character.velocity.x = movement_stick.x
		character.velocity.z = movement_stick.y

func falling():
	character.movement_state = FallingState.new()
	character.movement_state.initialize(character, last_aim, 0.0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
