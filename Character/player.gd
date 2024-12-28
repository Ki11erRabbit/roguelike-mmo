extends CharacterBody3D

const Actions = preload("res://InputManager/actions.gd")

@onready
var model = $BaseCharacter
@onready
var hitbox = $CollisionShape3D

const X_ROTATION_AMOUNT: float = -15

#const SPEED = 5.0
const SPEED = 0.5
const DIRECTION_RESTRICT = 0.9
const LOOK_RESTRICT = 0.8
# Determines the angle that allows for playing the rotation animation
const ROTATION_ANGLE_LIMIT: float = 10

var jump_pressed_time: float = 0.0
var jumping: bool = false
const JUMP_VELOCITY = 100
var fall_time: float = 0.0
var falling: bool = false

var last_aim: Vector2 = Vector2(0, 0)

func _ready() -> void:
	InputManager.start_game()

func _physics_process(delta: float) -> void:
	
	handle_movement_input(delta)
	
	handle_ground_movement()
	
	handle_gravity(delta)
	move_and_slide()

func handle_ground_movement():
	var move_direction = InputManager.get_stick_vector(Actions.PlayerActionSticks.Movement)
	var normalized_move = move_direction.normalized()
	var aim_direction = InputManager.get_stick_vector(Actions.PlayerActionSticks.Aim)
	var normalized_aim = aim_direction.normalized()
	
	var rotating: bool = false
	var clockwise_rotation: bool = is_rotating_clockwise(aim_direction.angle(), last_aim.angle())
	var aim_direction_was_zero: bool = (aim_direction.x == 0 and aim_direction.y == 0)
	var backstepping: bool = false
	var running: bool = false
	
	
	if aim_direction.x == 0 and aim_direction.y == 0:
		aim_direction = last_aim
		normalized_aim = last_aim.normalized()
	
	#current_aim_angle = lerp_angle(last_aim_angle, current_aim_angle, 0.1)
	model.rotation.x = 0
	hitbox.rotation.x = 0
	model.rotation.z = 0
	hitbox.rotation.z = 0
	model.rotation.y = atan2(aim_direction.x, aim_direction.y)
	hitbox.rotation.y = model.rotation.y
	hitbox.rotate_x(deg_to_rad(X_ROTATION_AMOUNT))
	model.rotate_x(deg_to_rad(X_ROTATION_AMOUNT))
	
	if (not aim_direction_was_zero) and rad_to_deg(abs(aim_direction.angle() - last_aim.angle())) < ROTATION_ANGLE_LIMIT:
		rotating = true
	last_aim = aim_direction
	
	var moving: bool = false
	
	var movement_vec = move_direction * 100
	#print(movement_vec)
	
	if (movement_vec.y > 50 or movement_vec.y < -50) or (movement_vec.x > 50 or movement_vec.x < -50):
		if not falling and not jumping:
			model.start_running()
			running = true
		moving = true
		#print("running")
	elif movement_vec.x != 0 or movement_vec.y != 0:
		if not falling and not jumping:
			model.start_walking()
		moving = true
		#print("walking")
	elif not jumping and not falling:
		#model.start_standing()
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
			if not falling and not jumping:
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
			if not falling and not jumping:
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
			if not falling and not jumping:
				model.start_backstepping()
	# Moving to the Left
	elif Vector2.LEFT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		#print("Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			pass
			#print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			#print("backwards")
			if not falling and not jumping:
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
			if not falling and not jumping:
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
			if not falling and not jumping:
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
			if not falling and not jumping:
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
			#print("backwards")
			if not falling and not jumping:
				model.start_backstepping()
	else:
		if rotating and not moving and not jumping and not falling:
			if clockwise_rotation:
				model.rotate_right()
			else:
				model.rotate_left()
		elif not jumping and not falling and not moving:
			model.start_standing()
		
	

	if backstepping:
		movement_vec = movement_vec * (SPEED / 2)
		velocity.x = movement_vec.x
		velocity.z = movement_vec.y
	else:
		movement_vec = movement_vec * SPEED
		velocity.x = movement_vec.x
		velocity.z = movement_vec.y

func handle_movement_input(delta: float):
	
	if InputManager.is_action_just_released(Actions.PlayerActionButtons.Jump) and is_on_floor():
		velocity.y += JUMP_VELOCITY
		model.jump()
		jumping = true
		pass
	elif InputManager.is_action_pressed(Actions.PlayerActionButtons.Jump):
		pass
	
	if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack):
		model.equip_right_handed_sword()
	if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.Interact):
		model.unequip()

func handle_gravity(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0.0:
			fall_time += delta
			if not falling:
				model.start_falling()
				falling = true
				jumping = false
	elif falling and is_on_floor():
		print(fall_time)
		print(velocity)
		if fall_time < 8 and fall_time > 0:
			model.short_fall_landing()
		elif fall_time >= 8 and fall_time < 20:
			model.medium_fall_landing()
		falling = false
		fall_time = 0

	
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
	
	
