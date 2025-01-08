class_name SwordRightHandedClockwiseSpin extends "res://Character/WeaponStateMachine/SwordRightHanded/sword_right_handed_state.gd"

const COOLDOWN_TIME: float = 0.2
var cooldown: float = COOLDOWN_TIME

var enable_cooldown: bool = false

func initialize(character: Character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	character.model.animation_finished.connect(start_cooldown)
	play_body_animation("clockwise_spin")
	play_animation("spin_clockwise")
	character.movement_state_machine.disable_input = true
	character.right_hand_weapon.enabled = false
	state_machine.weapon.enable_collision = true

func process_attack(delta: float, _attack: WeaponStateMachine.AttackType, _is_spinning: WeaponStateMachine.Spinning, _facing_forwards: bool) -> WeaponAction:
	if not enable_cooldown:
		enable_cooldown = true
		return null
	
	if cooldown <= 0.0:
		character.movement_state_machine.disable_input = false
		character.right_hand_weapon.enabled = true
		play_body_animation("idle")
		return reset()
	cooldown -= delta
	return null

func start_cooldown(anim_name: StringName):
	match String(anim_name):
		"clockwise_spin":
			enable_cooldown = true
			state_machine.weapon.enable_collision = false
			character.model.animation_finished.disconnect(start_cooldown)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
