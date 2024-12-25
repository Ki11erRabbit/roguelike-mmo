extends CharacterBody3D

const Actions = preload("res://InputManager/actions.gd")

@onready
var model = $BaseCharacter

const SPEED = 5.0
#const SPEED = 300.0
const DIRECTION_RESTRICT = 0.9
const LOOK_RESTRICT = 0.8
# Determines the angle that allows for playing the rotation animation
const ROTATION_ANGLE_LIMIT: float = 10
const JUMP_VELOCITY = 4.5

var last_aim: Vector2 = Vector2(0, 0)


func _physics_process(delta: float) -> void:
	var move_direction = InputManager.get_stick_vector(Actions.PlayerActionSticks.Movement)
	var normalized_move = move_direction.normalized()
	var aim_direction = InputManager.get_stick_vector(Actions.PlayerActionSticks.Aim)
	var normalized_aim = aim_direction.normalized()
	
	var rotating: bool = false
	var clockwise_rotation: bool = is_rotating_clockwise(aim_direction.angle(), last_aim.angle())
	var aim_direction_was_zero: bool = (aim_direction.x == 0 and aim_direction.y == 0)
	
	
	if aim_direction.x == 0 and aim_direction.y == 0:
		aim_direction = last_aim
		normalized_aim = last_aim.normalized()
	
	#current_aim_angle = lerp_angle(last_aim_angle, current_aim_angle, 0.1)
	model.rotation.y = atan2(aim_direction.x, aim_direction.y)
	
	
	if (not aim_direction_was_zero) and rad_to_deg(abs(aim_direction.angle() - last_aim.angle())) < ROTATION_ANGLE_LIMIT:
		rotating = true
	last_aim = aim_direction
	
	var moving: bool = false
	
	var movement_vec = move_direction * 100
	#print(movement_vec)
	
	if (movement_vec.y > 50 or movement_vec.y < -50) or (movement_vec.x > 50 or movement_vec.x < -50):
		model.start_running()
		moving = true
		#print("running")
	elif movement_vec.x != 0 or movement_vec.y != 0:
		model.start_walking()
		moving = true
		#print("walking")
	else:
		model.start_standing()
		moving = false
		#print("standing")
	
	# Moving Downwards
	if Vector2.DOWN.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Down")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			#print("backwards")
			model.start_backstepping()
	# Moving Upwards
	elif Vector2.UP.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Up")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			#print("backwards")
			model.start_backstepping()
	# Moving to the Right
	elif Vector2.RIGHT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			#print("backwards")
			model.start_backstepping()
	# Moving to the Left
	elif Vector2.LEFT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			#print("backwards")
			model.start_backstepping()
	# Moving to the Top Right
	elif Vector2.RIGHT.rotated(deg_to_rad(-45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Top Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			#print("backwards")
			model.start_backstepping()
	# Moving to the Bottom Right
	elif Vector2.RIGHT.rotated(deg_to_rad(45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Bottom Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			#print("backwards")
			model.start_backstepping()
	# Moving to the Top Left
	elif Vector2.LEFT.rotated(deg_to_rad(45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Top Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			#print("backwards")
			model.start_backstepping()
	# Moving to the Bottom Left
	elif Vector2.LEFT.rotated(deg_to_rad(-45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Bottom Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			pass
			#print("backwards")
	else:
		model.start_standing()
		if rotating and not moving:
			if clockwise_rotation:
				model.rotate_right()
			else:
				model.rotate_left()
		else:
			model.stop_rotating()
			model.start_standing()
		
	

	
	
	
	
	return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

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
	
	
