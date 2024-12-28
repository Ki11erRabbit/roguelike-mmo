class_name Player extends CharacterBody3D

const Actions = preload("res://InputManager/actions.gd")

@onready
var model = $BaseCharacter
@onready
var hitbox = $CollisionShape3D

var movement_state: CharacterMovementState = StandingState.new()

const X_ROTATION_AMOUNT: float = -15

#const SPEED = 5.0
const SPEED = 0.5
const DIRECTION_RESTRICT = 0.9
const LOOK_RESTRICT = 0.8
# Determines the angle that allows for playing the rotation animation
const ROTATION_ANGLE_LIMIT: float = 10
var last_aim: Vector2 = Vector2(0, 0)
var can_move: bool = true

var jump_pressed_time: float = 0.0
var jumping: bool = false
const JUMP_VELOCITY = 8
var fall_time: float = 0.0
var falling: bool = false

var equipped_sword: bool = false
var slash_count: int = 0
var slash_delta: float = 0.0

func _ready() -> void:
	movement_state.initialize(self, Vector2(0,0))
	InputManager.start_game()

func _physics_process(delta: float) -> void:
	
	movement_state.apply_current_state(delta)
	#handle_movement_input(delta)
	#
	#handle_ground_movement()
	#
	#handle_gravity(delta)
	move_and_slide()


func handle_movement_input(delta: float):
	
	if InputManager.is_action_just_released(Actions.PlayerActionButtons.Jump) and is_on_floor():
		velocity.y += JUMP_VELOCITY
		model.jump()
		jumping = true
		can_move = false
		pass
	elif InputManager.is_action_pressed(Actions.PlayerActionButtons.Jump):
		pass
	
	if slash_count > 0:
		slash_delta += delta
	if slash_delta > 0.5:
		slash_count = 0
		slash_delta = 0.0
		model.right_hand_reset()
		
	
	if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack):
		if not equipped_sword:
			equipped_sword = true
			model.equip_right_handed_sword()
		else:
			InputManager.add_cooldown(Actions.PlayerActionButtons.RightAttack, 0.2)
			slash_count += 1
			if slash_count == 1:
				model.right_hand_slash1()
				slash_delta = 0.0
			elif slash_count == 2 and slash_delta <= 0.5:
				model.right_hand_slash2()
				slash_count = 0
				slash_delta = 0.0
	if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.Interact):
		model.unequip()
		equipped_sword = false
		slash_delta = 0.0
	
