class_name SwordBothHandedSwing2State extends "res://Character/WeaponStateMachine/SwordBothHanded/sword_both_handed_state.gd"

const COOLDOWN_TIME: float = 0.5
var cooldown: float = COOLDOWN_TIME

var enable_cooldown: bool = false

func initialize(character: Character, state_machine: WeaponStateMachine):
	super(character, state_machine)
	character.model.animation_finished.connect(start_cooldown)
	play_animation("slash2")
	state_machine.weapon.enable_collision = true

func process_attack(delta: float, _attack: WeaponStateMachine.AttackType, _is_spinning: WeaponStateMachine.Spinning, _facing_forwards: bool) -> WeaponAction:
	if not enable_cooldown:
		return null
	
	if cooldown <= 0.0:
		return reset()
	cooldown -= delta
	return null

func start_cooldown(anim_name: StringName):
	match String(anim_name):
		"sword_both_hand_slash2":
			enable_cooldown = true
			state_machine.weapon.enable_collision = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
