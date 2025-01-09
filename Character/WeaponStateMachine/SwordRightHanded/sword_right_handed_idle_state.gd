class_name SwordRightHandedIdleState extends "res://Character/WeaponStateMachine/SwordRightHanded/sword_right_handed_state.gd"

# This makes it so that spin attacks can't be spammed but also prevents a lockup from doing two spin attacks in a row
var SPIN_ATTACK_COOLDOWN: float = 0.5
var spin_attack_cooldown: float = 0

func initialize(character: Character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	play_animation("idle")
	spin_attack_cooldown = SPIN_ATTACK_COOLDOWN

func process_attack(delta: float, attack: AttackType, is_spinning: Spinning, facing_forwards: bool) -> WeaponAction:
	if spin_attack_cooldown <= 0:
		match is_spinning:
			WeaponStateMachine.Spinning.Clockwise:
				match attack:
					AttackType.Normal:
						clockwise_spin()
						weapon_action.set_priority(10)
						return weapon_action
			WeaponStateMachine.Spinning.CounterClockwise:
				match attack:
					AttackType.Normal:
						counter_clockwise_spin()
						weapon_action.set_priority(10)
						return weapon_action
	else:
		spin_attack_cooldown -= delta
	#print("facing")
	
	if facing_forwards:
		match attack:
			AttackType.Normal:
				stab()
				weapon_action.set_priority(0)
				return weapon_action
	#print("checking attack")
	match attack:
		AttackType.Normal:
			swing()
			weapon_action.set_priority(0)
			return weapon_action
	return null

func swing():
	state_machine.state = SwordRightHandedSwing1State.new()
	state_machine.state.initialize(character, state_machine)

func stab():
	#character.play_animation("idle", "sword", "right")
	state_machine.state = SwordRightHandedStabState.new()
	state_machine.state.initialize(character, state_machine)

func clockwise_spin():
	state_machine.state = SwordRightHandedClockwiseSpin.new()
	state_machine.state.initialize(character, state_machine)

func counter_clockwise_spin():
	state_machine.state = SwordRightHandedCounterClockwiseSpin.new()
	state_machine.state.initialize(character, state_machine)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
