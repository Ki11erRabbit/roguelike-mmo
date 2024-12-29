class_name WeaponState extends Node

const AttackType = WeaponStateMachine.AttackType
const Spinning = WeaponStateMachine.Spinning

var character
var state_machine: WeaponStateMachine

func initialize(character, state_machine: WeaponStateMachine):
	self.character = character
	self.state_machine = state_machine

func process_attack(delta: float, attack: WeaponStateMachine.AttackType, is_spinning: WeaponStateMachine.Spinning, facing_forwards: bool) -> int:
	"""
	returns: An integer indicating whether or not to block any other state_machines with a priorty
	"""
	return false

func reset():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
