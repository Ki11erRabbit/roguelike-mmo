class_name SwordBothHandedState extends "res://Character/WeaponStateMachine/weapon_state.gd"

func initialize(character: Character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	weapon = "sword"
	hand = "both"

func reset():
	state_machine.state = SwordBothHandedIdleState.new()
	state_machine.state.initialize(character, state_machine)

func swing():
	pass

func stab():
	pass

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
