class_name SwordRightHandedIdleState extends "res://Character/WeaponStateMachine/SwordRightHanded/sword_right_handed_state.gd"


func initialize(character: Character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	play_animation("idle")

func process_attack(delta: float, attack: AttackType, is_spinning: Spinning, facing_forwards: bool) -> int:
	match is_spinning:
		WeaponStateMachine.Spinning.Clockwise:
			match attack:
				AttackType.Normal:
					print("spin attack")
					clockwise_spin()
					return 10
		WeaponStateMachine.Spinning.CounterClockwise:
			match attack:
				AttackType.Normal:
					counter_clockwise_spin()
					return 10
	#print("facing")
	
	if facing_forwards:
		match attack:
			AttackType.Normal:
				stab()
				return 0
	#print("checking attack")
	match attack:
		AttackType.Normal:
			swing()
			return 0
	return 0

func swing():
	#character.play_animation("idle", "sword", "right")
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
