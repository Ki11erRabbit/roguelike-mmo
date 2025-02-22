class_name SwordBothHandedStabState extends "res://Character/WeaponStateMachine/SwordBothHanded/sword_both_handed_state.gd"

func initialize(character: Character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	character.model.animation_finished.connect(start_cooldown)
	play_animation("thrust")
	state_machine.weapon.enable_collision = true

func process_attack(_delta: float, _attack: WeaponStateMachine.AttackType, _is_spinning: WeaponStateMachine.Spinning, _facing_forwards: bool) -> WeaponAction:
	
	return null

func start_cooldown(anim_name: StringName):
	match String(anim_name):
		"sword_both_hand_thrust":
			reset()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
