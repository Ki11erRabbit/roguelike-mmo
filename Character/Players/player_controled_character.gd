class_name PlayerControlledCharacter extends "res://Character/character.gd"

const Actions = preload("res://InputManager/actions.gd")

var should_equip: bool = false


func ready_character():
	
	stats = CharacterStats.new()
	stats.setup_new(1, 1, 1, 5, HumanCalculator.new())
	
	
	var model_to_use = load("res://Character/BaseCharacter/base_character.tscn").instantiate()
	var character_model: CharacterModel = load("res://Character/CharacterModel.tscn").instantiate()
	character_model.initialize(model_to_use)
	
	var capsule_shape = collision_box.shape
	
	#var box: PlayerControlBox = PlayerControlBox.new()
	var box: RemoteControlBox = $RemoteControlBox
	
	initialize(character_model, capsule_shape, box)
	
	var sword: Weapon = load("res://Weapons/Concrete/Swords/test_sword.tscn").instantiate()
	sword.initialize(self)
	#sword.position = Vector3(-0.24, -0.1, 0.037)
	#sword.rotation = Vector3(61.9, 157.2, -137.6)
	var weapon_state_machine = WeaponStateMachine.new()
	var weapon_state = SwordRightHandedIdleState.new()
	weapon_state.initialize(self, weapon_state_machine)
	weapon_state_machine.initialize(self, WeaponStateMachine.HandedNess.Right, weapon_state, sword)
	
	attach_right_hand_weapon(sword, weapon_state_machine)
	
	InputManager.start_game()
	

func process_character(delta: float):
	if should_equip:
		equip_weapons()
		should_equip = false
	
	
	if control_box.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack):
		if not weapons_equiped:
			should_equip = true
	if control_box.is_action_just_pressed(Actions.PlayerActionButtons.Interact):
		if weapons_equiped:
			unequip_weapons()
			should_equip = false

	
	return false

func process_health_bar_position():
	pass
