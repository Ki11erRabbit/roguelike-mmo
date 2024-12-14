extends CharacterBody2D

var BaseCharacter = preload("res://Character/BaseCharacter.tscn").instantiate()

const SPEED = 300.0
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
	if normalized_move.y > 0 and (normalized_move.x < 0.4 and normalized_move.x > -0.4):
		var x = BaseCharacter.FacingDirection.Down
		player_model.set_current_facing_direction(x)
	elif normalized_move.y > 0 and normalized_move.x >= 0.4:
		print("diagonal")
		pass
	elif normalized_move.y > 0 and normalized_move.x <= -0.4:
		print("diagonal")
		pass
	elif normalized_move.y < 0 and (normalized_move.x < 0.4 and normalized_move.x > -0.4):
		pass
	elif normalized_move.y < 0 and normalized_move.x >= 0.4:
		print("diagonal")
		pass
	elif normalized_move.y < 0 and normalized_move.x <= -0.4:
		print("diagonal")
		pass
	else:
		player_model.stop_moving()
	
	if normalized_aim.dot(normalized_move) > 0.9:
		walking_direction = BaseCharacter.WalkingDirection.Forwards
		print("forwards")
	elif normalized_aim.dot(normalized_move) < 0.9:
		walking_direction = BaseCharacter.WalkingDirection.Backwards
		print("backwards")
	
	var movement_vec = move_direction * 100
	print(movement_vec)
	
	if (movement_vec.y > 50 or movement_vec.y < -50) or (movement_vec.x > 50 or movement_vec.x < -50):
		player_model.start_running(walking_direction)
		print("running")
	else:
		player_model.start_walking(walking_direction)
		print("walking")
	
		
	
	velocity = move_direction * SPEED
	
	
	
	move_and_slide()