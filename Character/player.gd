class_name Player extends CharacterBody3D

const Actions = preload("res://InputManager/actions.gd")

@onready
var model = $BaseCharacter
@onready
var hitbox = $CollisionShape3D

var movement_state: CharacterMovementState = StandingState.new()
var weapon_state_machine: WeaponStateMachine = WeaponStateMachine.new()

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
	pass
	#movement_state.initialize(self, Vector2(0,0))
	#weapon_state_machine.initialize(self, WeaponStateMachine.HandedNess.Right, SwordRightHandedIdleState.new())
	#InputManager.start_game()

func _physics_process(delta: float) -> void:
	pass
	#movement_state.apply_current_state(delta)
	#weapon_state_machine.process_input(delta)
	#
	#if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack):
		#if not equipped_sword:
			#equipped_sword = true
			#model.equip_right_handed_sword()
			#var sword_container = get_children().pop_back()
			#remove_child(sword_container)
			#sword_container.visible = true
			#model.equip_right_hand(sword_container)
			#weapon_state_machine.enabled = true
	#if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.Interact):
		#if equipped_sword:
			#model.unequip()
			#equipped_sword = false
			#var sword_container = model.unequip_right_hand()
			#sword_container.visible = false
			#add_child(sword_container)
			#weapon_state_machine.enabled = false
	##handle_movement_input(delta)
	##
	##handle_ground_movement()
	##
	##handle_gravity(delta)
	#move_and_slide()
