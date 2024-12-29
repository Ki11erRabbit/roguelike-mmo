class_name WeaponStateMachine extends Node

const Actions = preload("res://InputManager/actions.gd")

enum HandedNess { Left, Both, Right }
enum AttackType { None, Normal, Strong }
enum Spinning { None, Clockwise, CounterClockwise }

var character
var state: WeaponState
var handedness: HandedNess

var already_fired: bool = false
var enabled: bool = false

var last_angle: float = 0


func initialize(character, handedness: HandedNess, state: WeaponState):
	self.character = character
	self.state = state
	self.handedness = handedness
	self.state.initialize(character, self)

func process_input(delta: float) -> int:
	if already_fired or not enabled:
		return 0
	
	var attack: AttackType = AttackType.None
	 
	
	match handedness:
		HandedNess.Left:
			if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.LeftAttack):
				attack = AttackType.Normal
			elif InputManager.is_action_just_pressed(Actions.PlayerActionButtons.LeftStrongAttack):
				attack = AttackType.Strong
		HandedNess.Both:
			if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack) or InputManager.is_action_just_pressed(Actions.PlayerActionButtons.LeftAttack):
				attack = AttackType.Normal
			elif InputManager.is_action_just_pressed(Actions.PlayerActionButtons.RightStrongAttack) or InputManager.is_action_just_pressed(Actions.PlayerActionButtons.LeftStrongAttack):
				attack = AttackType.Strong
		HandedNess.Right:
			if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack):
				attack = AttackType.Normal
			elif InputManager.is_action_just_pressed(Actions.PlayerActionButtons.RightStrongAttack):
				attack = AttackType.Strong
	
	var current_aim: Vector2 = InputManager.get_stick_vector(Actions.PlayerActionSticks.Aim)
	var current_angle: float = current_aim.angle()
	
	
	var spinning: Spinning = Spinning.None
	# TODO: add spinning
		
	var movement_angle = InputManager.get_stick_vector(Actions.PlayerActionSticks.Movement).angle()
	
	# TODO: get facing to work
	var facing_forwards: bool = abs(current_aim.normalized().dot(Vector2(1,1))) >= 0.8
	
	return state.process_attack(delta, attack, spinning, facing_forwards)
	
	

func calculate_mean(array: Array):
	var sum = 0
	for x in array:
		sum += rad_to_deg(x)
	
	return sum / (array.size() - 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	already_fired = false
