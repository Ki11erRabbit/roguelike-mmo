class_name WeaponStateMachine extends Node

const Actions = preload("res://InputManager/actions.gd")

enum HandedNess { Left, Both, Right }
enum AttackType { None, Normal, Strong }
enum Spinning { None, Clockwise, CounterClockwise }

var character: Character
var state: WeaponState
var handedness: HandedNess

var already_fired: bool = false
var enabled: bool = false

var last_angle: float = 0

# The state must be initialized before being passed in
func initialize(character: Character, handedness: HandedNess, state: WeaponState):
	self.character = character
	self.state = state
	self.handedness = handedness

func process_input(delta: float) -> int:
	if already_fired or not enabled or character.model.is_landing():
		return 0
	
	var attack: AttackType = AttackType.None
	 
	
	match handedness:
		HandedNess.Left:
			if character.control_box.is_action_just_pressed(Actions.PlayerActionButtons.LeftAttack):
				attack = AttackType.Normal
			elif character.control_box.is_action_just_pressed(Actions.PlayerActionButtons.LeftStrongAttack):
				attack = AttackType.Strong
		HandedNess.Both:
			if character.control_box.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack) or character.control_box.is_action_just_pressed(Actions.PlayerActionButtons.LeftAttack):
				attack = AttackType.Normal
			elif character.control_box.is_action_just_pressed(Actions.PlayerActionButtons.RightStrongAttack) or character.control_box.is_action_just_pressed(Actions.PlayerActionButtons.LeftStrongAttack):
				attack = AttackType.Strong
		HandedNess.Right:
			if character.control_box.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack):
				attack = AttackType.Normal
			elif character.control_box.is_action_just_pressed(Actions.PlayerActionButtons.RightStrongAttack):
				attack = AttackType.Strong
	
	var current_aim: Vector2 = character.control_box.aim()
	var current_angle: float = current_aim.angle()
	
	
	var spinning: Spinning = Spinning.None
	# TODO: add spinning
		
	var movement_angle = character.control_box.movement().angle()
	
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
