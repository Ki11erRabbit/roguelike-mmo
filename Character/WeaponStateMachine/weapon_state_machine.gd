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
const ANGLE_THRESHOLD: float = deg_to_rad(200.00)
var total_rotation: float
var angle_array: Array = []
var spin_counter: float = 0.0
var spinning: Spinning
var spin_mean: float



# The state must be initialized before being passed in
func initialize(character: Character, handedness: HandedNess, state: WeaponState):
	self.character = character
	self.state = state
	self.handedness = handedness

func process_input(delta: float) -> int:
	if not enabled:
		spin_counter = 0.0
		angle_array.resize(0)
		spinning = Spinning.None
		return 0
	if already_fired:
		spin_counter = 0.0
		angle_array.resize(0)
		spinning = Spinning.None
		return 0
	if character.is_landing():
		spin_counter = 0.0
		angle_array.resize(0)
		spinning = Spinning.None
		return 0
	
	#print(state.get_script().resource_path)
	
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
	
	
	spinning = Spinning.None
	# TODO: add spinning
	
	var angle_diff = angle_difference(last_angle, current_angle)
	
	if (angle_diff >= ANGLE_THRESHOLD) or (angle_diff <= -ANGLE_THRESHOLD):
		pass
	else:
		#angle_array.resize(angle_array.size() + 1)
		#print("angle diff")
		#print(deg_to_rad(angle_diff))
		angle_array.push_back(angle_diff)
	
	if angle_array.size() > 20:
		spin_mean = calculate_mean(angle_array)
		angle_array.resize(0)
		
	if spin_mean <= -8:
		#print("spinning")
		spinning = Spinning.CounterClockwise
		
		spin_counter += delta
	elif spin_mean >= 8:
		#print("spinning")
		#print(spin_mean)
		spinning = Spinning.Clockwise
		spin_counter += delta
	elif spin_counter >= 1:
		spin_counter = 0.0
	last_angle = current_angle
		
	var movement_angle = character.control_box.movement().angle()
	
	# TODO: get facing to work
	var facing_forwards: bool = abs(current_aim.normalized().dot(Vector2(1,1))) >= 0.8
	
	var result = state.process_attack(delta, attack, spinning, facing_forwards)
	return result
	
	

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
