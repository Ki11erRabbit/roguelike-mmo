extends CharacterBody2D

var BaseCharacter = preload("res://Character/BaseCharacter.tscn").instantiate()

const SPEED = 300.0
const DIRECTION_RESTRICT = 0.8
const LOOK_RESTRICT = 0.8

# Has type BaseCharacter.WalkingDirection
var walking_direction = BaseCharacter.WalkingDirection.Forwards

@onready
var player_model = $BaseCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var normalized_move = move_direction.normalized()
	var aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var normalized_aim = aim_direction.normalized()
	#print(move_direction)
	#print(normalized_move)
	
	#print(aim_direction)
	#print(rad_to_deg(Vector2.RIGHT.rotated(deg_to_rad(-45)).normalized().angle()))
	#print(rad_to_deg(Vector2.RIGHT.rotated(deg_to_rad(45)).normalized().angle()))

	# Moving Downwards
	if Vector2.DOWN.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Down")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Forwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Up)
			print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Backwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Down)
			print("backwards")
	# Moving Upwards
	elif Vector2.UP.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Up")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Backwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Down)
			print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Forwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Up)
			print("backwards")
	# Moving to the Right
	elif Vector2.RIGHT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Forwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Right)
			print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Backwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Left)
			print("backwards")
	# Moving to the Left
	elif Vector2.LEFT.normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Forwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Left)
			print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Backwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Right)
			print("backwards")
	# Moving to the Top Right
	elif Vector2.RIGHT.rotated(deg_to_rad(-45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Top Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Forwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.UpRight)
			print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Backwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.DownLeft)
			print("backwards")
	# Moving to the Bottom Right
	elif Vector2.RIGHT.rotated(deg_to_rad(45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Bottom Right")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Forwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.DownRight)
			print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Backwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.UpLeft)
			print("backwards")
	# Moving to the Top Left
	elif Vector2.LEFT.rotated(deg_to_rad(45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Top Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Forwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.UpLeft)
			print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Backwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.DownRight)
			print("backwards")
	# Moving to the Bottom Left
	elif Vector2.LEFT.rotated(deg_to_rad(-45)).normalized().dot(normalized_move) >= DIRECTION_RESTRICT:
		print("Bottom Left")
		if normalized_aim.x == 0 and normalized_aim.y == 0:
			pass
		elif normalized_aim.dot(normalized_move) >= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Forwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.DownLeft)
			print("forwards")
		elif normalized_aim.dot(normalized_move) <= LOOK_RESTRICT:
			walking_direction = BaseCharacter.WalkingDirection.Backwards
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.UpRight)
			print("backwards")
	else:
		player_model.stop_moving()
		var angle = aim_direction.angle()
		angle = rad_to_deg(angle)
		print(angle)
		if angle == 0:
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.LastDirection)
		elif angle > -100 and angle < -60:
			print("up")
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Up)
		elif angle < 100 and angle > 60:
			print("down")
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Down)
		elif angle > -20 and angle < 20:
			print("right")
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Right)
		elif angle < -160 or angle > 160:
			print("left")
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.Left)
		elif angle > -60 and angle < -20:
			print("diagonal up right")
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.UpRight)
		elif angle > 20 and angle < 60:
			print("diagonal down right")
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.DownRight)
		elif angle < -100 and angle > -160:
			print("diagonal up left")
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.UpLeft)
		elif angle > 100 and angle < 160:
			print("diagonal down left")
			player_model.set_current_facing_direction(BaseCharacter.FacingDirection.DownLeft)
	
	
	var movement_vec = move_direction * 100
	#print(movement_vec)
	
	if (movement_vec.y > 50 or movement_vec.y < -50) or (movement_vec.x > 50 or movement_vec.x < -50):
		player_model.start_running(walking_direction)
		print("running")
	else:
		player_model.start_walking(walking_direction)
		print("walking")
	
		
	
	velocity = move_direction * SPEED
	
	
	
	move_and_slide()
