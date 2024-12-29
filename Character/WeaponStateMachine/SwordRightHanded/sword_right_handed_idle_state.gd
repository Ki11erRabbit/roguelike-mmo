class_name SwordRightHandedIdleState extends "res://Character/WeaponStateMachine/SwordRightHanded/sword_right_handed_state.gd"


func initialize(character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	character.model.right_hand_reset()

func process_attack(delta: float, attack: AttackType, is_spinning: Spinning, facing_forwards: bool) -> int:
	if attack == 1:
		print("normal attack")
	match is_spinning:
		WeaponStateMachine.Spinning.Clockwise:
			match attack:
				AttackType.Normal:
					print("spinning")
					clockwise_spin()
					return 10
		WeaponStateMachine.Spinning.CounterClockwise:
			match attack:
				AttackType.Normal:
					counter_clockwise_spin()
					print("spinning")
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
			print("attacking")
			swing()
			return 0
	return 0

func swing():
	character.model.right_hand_reset()
	state_machine.state = SwordRightHandedSwing1State.new()
	state_machine.state.initialize(character, state_machine)

func stab():
	character.model.right_hand_reset()
	state_machine.state = SwordRightHandedStabState.new()
	state_machine.state.initialize(character, state_machine)

func clockwise_spin():
	pass

func counter_clockwise_spin():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
