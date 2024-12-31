class_name MovingState extends "res://Character/MovementStateMachine/character_movement_state.gd"



enum MovingStates { None, Walking, Running, BackStepping, Strafing }
enum HorizontalStates { None, Left, Right }

var current_moving_state: MovingStates = MovingStates.None
var current_horizontal_state: HorizontalStates = HorizontalStates.None
const DIRECTION_RESTRICT = 0.9
const LOOK_RESTRICT = 0.8
const STRAFE_RESTRICT = 0.3

func initialize(character: Character, current_last_aim: Vector2, additional = null):
	super(character, current_last_aim)
	character.play_body_animation("Movement")

func apply_current_state(delta: float):
	process_rotation(delta)
	if process_movement_buttons(self):
		return
		
	process_gravity(delta, self)
	
	process_movement(self)
	
	var move_direction =  character.control_box.movement()
	var normalized_move = move_direction.normalized()
	var aim_direction =  character.control_box.aim()
	var normalized_aim = aim_direction.normalized()
	
	var new_movement_state: MovingStates = current_moving_state
	var new_horizontal_state: HorizontalStates = current_horizontal_state
	if aim_direction.x == 0 and aim_direction.y == 0:
		aim_direction = last_aim
		normalized_aim = last_aim.normalized()
	
	var movement_vec = move_direction * 100
	#print(movement_vec)
	
	if (movement_vec.y > 50 or movement_vec.y < -50) or (movement_vec.x > 50 or movement_vec.x < -50):
		new_movement_state = MovingStates.Running
	elif movement_vec.x != 0 or movement_vec.y != 0:
		new_movement_state = MovingStates.Walking
		
	# The dot product tells us how close the vectors align
	# 1 means that they are aligned
	# 0 means that they are perpendicular
	# -1 means that they are in opposite directions
	# Moving Downwards
	if Vector2.DOWN.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Down")
		new_movement_state = get_state(normalized_move, normalized_aim, new_movement_state)
		match new_movement_state:
			MovingStates.Strafing:
				var dot_product: float = Vector2.RIGHT.normalized().dot(normalized_aim)
				#print(dot_product)
				if dot_product >= LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Right
				elif dot_product <= -LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Left
	# Moving Upwards
	elif Vector2.UP.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Up")
		new_movement_state = get_state(normalized_move, normalized_aim, new_movement_state)
		match new_movement_state:
			MovingStates.Strafing:
				var dot_product: float = Vector2.RIGHT.normalized().dot(normalized_aim)
				#print(dot_product)
				if dot_product >= LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Left
				elif dot_product <= -LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Right
	# Moving to the Right
	elif Vector2.RIGHT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Right")
		new_movement_state = get_state(normalized_move, normalized_aim, new_movement_state)
		match new_movement_state:
			MovingStates.Strafing:
				var dot_product: float = Vector2.UP.normalized().dot(normalized_aim)
				#print(dot_product)
				if dot_product >= LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Right
				elif dot_product <= -LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Left
	# Moving to the Left
	elif Vector2.LEFT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Left")
		new_movement_state = get_state(normalized_move, normalized_aim, new_movement_state)
		match new_movement_state:
			MovingStates.Strafing:
				var dot_product: float = Vector2.UP.normalized().dot(normalized_aim)
				if dot_product >= LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Left
				elif dot_product <= -LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Right
	# Moving to the Top Right
	elif Vector2.RIGHT.rotated(deg_to_rad(-45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Top Right")
		new_movement_state = get_state(normalized_move, normalized_aim, new_movement_state)
		match new_movement_state:
			MovingStates.Strafing:
				var dot_product: float = Vector2.UP.rotated((deg_to_rad(-45))).normalized().dot(normalized_aim)
				#print(dot_product)
				if dot_product >= LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Right
				elif dot_product <= -LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Left
	# Moving to the Bottom Right
	elif Vector2.RIGHT.rotated(deg_to_rad(45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Bottom Right")
		new_movement_state = get_state(normalized_move, normalized_aim, new_movement_state)
		match new_movement_state:
			MovingStates.Strafing:
				var dot_product: float = Vector2.UP.rotated((deg_to_rad(45))).normalized().dot(normalized_aim)
				#print(dot_product)
				if dot_product >= LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Right
				elif dot_product <= -LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Left
	# Moving to the Top Left
	elif Vector2.LEFT.rotated(deg_to_rad(45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Top Left")
		new_movement_state = get_state(normalized_move, normalized_aim, new_movement_state)
		match new_movement_state:
			MovingStates.Strafing:
				var dot_product: float = Vector2.UP.rotated((deg_to_rad(45))).normalized().dot(normalized_aim)
				if dot_product >= LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Left
				elif dot_product <= -LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Right
	# Moving to the Bottom Left
	elif Vector2.LEFT.rotated(deg_to_rad(-45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Bottom Left")
		new_movement_state = get_state(normalized_move, normalized_aim, new_movement_state)
		match new_movement_state:
			MovingStates.Strafing:
				var dot_product: float = Vector2.UP.rotated((deg_to_rad(-45))).normalized().dot(normalized_aim)
				if dot_product >= LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Left
				elif dot_product <= -LOOK_RESTRICT:
					new_horizontal_state = HorizontalStates.Right
	else:
		new_movement_state = MovingStates.None
	
	
	if current_moving_state != new_movement_state:
		current_moving_state = new_movement_state
		match current_moving_state:
			MovingStates.Walking:
				character.play_body_animation("walk")
				current_horizontal_state = HorizontalStates.None
			MovingStates.Running:
				character.play_body_animation("run")
				current_horizontal_state = HorizontalStates.None
			MovingStates.BackStepping:
				character.play_body_animation("backstep")
				current_horizontal_state = HorizontalStates.None
			MovingStates.Strafing:
				if current_horizontal_state != new_horizontal_state:
					current_horizontal_state = new_horizontal_state
					match current_horizontal_state:
						HorizontalStates.Right:
							character.play_body_animation("side_step_right")
						HorizontalStates.Left:
							character.play_body_animation("side_step_left")
			MovingStates.None:
				stand()

func get_state(normalized_move, normalized_aim, current_state: MovingStates) -> MovingStates:
	var dot_product: float = normalized_aim.dot(normalized_move)
	if normalized_aim.x == 0 and normalized_aim.y == 0:
		return current_state
	elif dot_product >= LOOK_RESTRICT:
		# Forwards
		return current_state
	elif dot_product <= STRAFE_RESTRICT and dot_product >= -STRAFE_RESTRICT:
		# Strafing
		return MovingStates.Strafing
	elif dot_product <= LOOK_RESTRICT:
		# Backwards
		return MovingStates.BackStepping
	else:
		return current_state

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
