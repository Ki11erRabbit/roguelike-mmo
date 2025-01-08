class_name WeaponState extends Node

const AttackType = WeaponStateMachine.AttackType
const Spinning = WeaponStateMachine.Spinning

var character: Character
var state_machine: WeaponStateMachine

var weapon: String = ""
var hand: String = ""

var weapon_action:
	get():
		return self.state_machine.weapon_action

func initialize(character: Character, state_machine: WeaponStateMachine):
	self.character = character
	self.state_machine = state_machine
	self.state_machine.weapon_action = WeaponAction.new()
	self.state_machine.weapon_action.initialize(character)

## returns: An integer indicating whether or not to block any other state_machines with a priorty
func process_attack(delta: float, attack: WeaponStateMachine.AttackType, is_spinning: WeaponStateMachine.Spinning, facing_forwards: bool) -> WeaponAction:
	return null

func play_animation(anim_name: String):
	self.state_machine.weapon_action.set_animation(anim_name, weapon, hand)

func play_body_animation(anim_name: String):
	self.state_machine.weapon_action.set_body_animation(anim_name)
	

func reset():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
