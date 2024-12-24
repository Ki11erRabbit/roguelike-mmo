extends CharacterBody3D


const SPEED = 5.0
#const SPEED = 300.0
const DIRECTION_RESTRICT = 0.8
const LOOK_RESTRICT = 0.8
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var normalized_move = move_direction.normalized()
	var aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var normalized_aim = aim_direction.normalized()
	
	var movement_vec = move_direction * 100
	#print(movement_vec)
	
	if (movement_vec.y > 50 or movement_vec.y < -50) or (movement_vec.x > 50 or movement_vec.x < -50):
		$BaseCharacter.start_running()
		print("running")
	elif movement_vec.x != 0 or movement_vec.y != 0:
		$BaseCharacter.start_walking()
		print("walking")
	else:
		$BaseCharacter.start_standing()
		print("standing")
	
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
