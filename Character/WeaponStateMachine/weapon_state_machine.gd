class_name WeaponStateMachine extends Node

const Actions = preload("res://InputManager/actions.gd")

enum HandedNess { Left, Both, Right }
enum AttackType { None, Normal, Strong }
enum Spinning { None, Clockwise, CounterClockwise }

var character
var state: WeaponState
var handedness: HandedNess

var already_fired: bool = false

const ANGLE_THRESHOLD : float = deg_to_rad(200.00)
var last_angle: float = 0
var total_rotation: float
var angle_array: Array = []
var spinning_clockwise = true
var spinning_anticlockwise: bool = false
var spin_counter: float = 0.0

func initialize(character, handedness: HandedNess, state: WeaponState):
	self.character = character
	self.state = state
	self.handedness = handedness
	self.state.initialize(character, self)

func process_input(delta: float) -> int:
	if already_fired:
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
	
	var angle_diff = angle_difference(last_angle, current_angle)
	if (angle_diff >= ANGLE_THRESHOLD) or (angle_diff <= -ANGLE_THRESHOLD):
		pass
	else:
		angle_array.push_back(angle_diff)
	
	if angle_array.size() > 20:
		var mean = calculate_mean(angle_array)
		if mean == 0:
			spinning_anticlockwise = false
			spinning_clockwise = false
		elif mean <= -8:
			#print("spinning")
			spinning_anticlockwise = true
			spin_counter += delta
		elif mean >= 8:
			spinning_clockwise = true
			spin_counter += delta
		elif (mean <= 8 or mean >= -8) and spin_counter >= 1.0:
			spinning_clockwise = false
			spinning_anticlockwise = false
			spin_counter = 0.0
		angle_array.resize(0)
	
	var spinning: Spinning = Spinning.None
	if spinning_clockwise:
		spinning = Spinning.Clockwise
	elif spinning_anticlockwise:
		spinning = Spinning.CounterClockwise
		
	var movement_angle = InputManager.get_stick_vector(Actions.PlayerActionSticks.Movement).angle()
	
	# TODO: get facing to work
	var facing_forwards: bool = current_aim.x != 0 or current_aim.y != 0
	
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
