class_name SwordRightHandedSwing2State extends "res://Character/WeaponStateMachine/SwordRightHanded/sword_right_handed_state.gd"

const COOLDOWN_TIME: float = 0.5
var cooldown: float = COOLDOWN_TIME

var enable_cooldown: bool = false

func initialize(character: Character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	character.model.animation_finished.connect(start_cooldown)
	play_animation("slash2")
	state_machine.weapon.enable_collision = true

func process_attack(delta: float, attack: WeaponStateMachine.AttackType, _is_spinning: WeaponStateMachine.Spinning, _facing_forwards: bool) -> WeaponAction:
	if not enable_cooldown:
		return null
	
	match attack:
		AttackType.Strong:
			two_handed_switch()
			return weapon_action
	
	if cooldown <= 0.0:
		return reset()
	cooldown -= delta
	return null

func start_cooldown(anim_name: StringName):
	match String(anim_name):
		"sword_right_hand_slash2":
			enable_cooldown = true
			state_machine.weapon.enable_collision = false
			character.model.animation_finished.disconnect(start_cooldown)

func two_handed_switch():
	# TODO: check if we can do this
	character.switch_to_two_handed(true)
	state_machine.state = SwordBothHandedSwing2State.new()
	state_machine.state.initialize(character, state_machine)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
