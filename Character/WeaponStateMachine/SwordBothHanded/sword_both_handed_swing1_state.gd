class_name SwordBothHandedSwing1State extends "res://Character/WeaponStateMachine/SwordBothHanded/sword_both_handed_state.gd"

const GRACE_TIME: float = 0.5
var grace_period: float = GRACE_TIME

var attacks_enabled: bool = false

var stuck_time: float = 0

func initialize(character: Character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	character.model.animation_finished.connect(enable_attacks)
	play_animation("slash1")

func process_attack(delta: float, attack: WeaponStateMachine.AttackType, is_spinning: WeaponStateMachine.Spinning, facing_forwards: bool) -> int:
	if not attacks_enabled and stuck_time < 1:
		stuck_time += delta
		return 0
	grace_period -= delta
	if grace_period <= 0.0:
		reset()
		return 0
	else:
		grace_period -= delta
	
	match attack:
		AttackType.Normal:
			swing()
			return 0
		AttackType.Strong:
			# TODO: Make it so that we can switch to two handed sword
			pass
		
	return 0

func swing():
	state_machine.state = SwordBothHandedSwing2State.new()
	state_machine.state.initialize(character, state_machine)

func enable_attacks(anim_name: StringName):
	match String(anim_name):
		"sword_both_hand_slash1":
			attacks_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
