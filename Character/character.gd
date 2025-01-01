class_name Character extends CharacterBody3D

var movement_state_machine: MovementStateMachine = MovementStateMachine.new()
var right_hand_weapon: WeaponStateMachine
var left_hand_weapon: WeaponStateMachine

var weapons_equiped: bool = false
enum AirState { Grounded, Jumping, Falling, Landing }
var air_state: AirState = AirState.Grounded

var model: CharacterModel

var control_box: ControlBox

@onready
var collision_box: CollisionShape3D = $CollisionShape3D

@onready
var right_hand = $Weapons/RightHand
@onready
var left_hand = $Weapons/LeftHand

func initialize(model: CharacterModel, collision_shape: CapsuleShape3D, box: ControlBox):
	"""
	This should be called in ready_character
	"""
	self.model = model
	add_child(model)
	collision_box.shape = collision_shape
	control_box = box
	movement_state_machine.initialize(self)

func ground():
	air_state = AirState.Grounded
func is_grounded():
	match air_state:
		AirState.Grounded:
			return true
	return false
func jump():
	air_state = AirState.Jumping
func is_jumping():
	match air_state:
		AirState.Jumping:
			return true
	return false
func fall():
	air_state = AirState.Falling
func is_falling():
	match air_state:
		AirState.Falling:
			return true
	return false
func land():
	air_state = AirState.Landing
func is_landing():
	match air_state:
		AirState.Landing:
			return true
	return false

func attach_right_hand_weapon(weapon: Weapon, state_machine: WeaponStateMachine):
	right_hand_weapon = state_machine
	right_hand.add_child(weapon)

func attach_left_hand_weapon(weapon: Weapon, state_machine: WeaponStateMachine):
	left_hand_weapon = state_machine
	left_hand.add_child(weapon)

func attach_two_handed_weapon(weapon: Weapon, state_machine: WeaponStateMachine):
	right_hand_weapon = state_machine
	left_hand_weapon = state_machine
	right_hand.add_child(weapon)

func switch_to_two_handed(right: bool):
	unequip()
	if right:
		left_hand_weapon = right_hand_weapon
	else:
		right_hand_weapon = left_hand_weapon
	equip("both")

func switch_to_one_handed(right: bool):
	unequip()
	if right:
		left_hand_weapon = null
		equip("right")
	else:
		right_hand_weapon = null
		equip("left")

func unequip():
	model.unequip()

func equip(hand: String):
	model.equip(hand)

func equip_weapons():
	var right_weapon: Node3D = null
	var left_weapon: Node3D = null
	if right_hand.get_child_count() == 1:
		right_weapon = right_hand.get_children().pop_back()
		right_hand.remove_child(right_weapon)
	
	if left_hand.get_child_count() == 1:
		left_weapon = left_hand.get_children().pop_back()
		left_hand.remove_child(left_weapon)
	
	model.equip_weapons(right_weapon, left_weapon)
	weapons_equiped = true

func unequip_weapons():
	var pair: Array[Node3D] = model.unequip_weapons()
	var right_weapon: Node3D = pair[0]
	var left_weapon: Node3D = pair[1]
	if right_weapon != null:
		right_hand.add_child(right_weapon)
	if left_weapon != null:
		left_hand.add_child(left_weapon)
	weapons_equiped = false

func play_animation(anim_name: String, weapon: String, hand: String):
	model.play_animation(anim_name, weapon, hand)

func play_body_animation(anim_name: String):
	model.play_body_animation(anim_name)

func process_character() -> bool:
	"""
	returns: Return value is a boolean indicating whether or not to not process other character functions
	true means to skip other character functions
	"""
	return false

func ready_character():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ready_character()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if process_character():
		return
	movement_state_machine.process_state(delta)
	if weapons_equiped:
		if right_hand_weapon != null:
			right_hand_weapon.enabled = true
			right_hand_weapon.process_input(delta)
		if left_hand_weapon != null:
			left_hand_weapon.enabled = true
			left_hand_weapon.process_input(delta)
	elif right_hand_weapon != null and left_hand_weapon != null:
		if right_hand_weapon != null:
			right_hand_weapon.enabled = false
		if left_hand_weapon != null:
			left_hand_weapon.enabled = false
		
	move_and_slide()
