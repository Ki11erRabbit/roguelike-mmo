extends "res://Character/character.gd"

const Actions = preload("res://InputManager/actions.gd")

var should_equip: bool = false


func ready_character():
	
	
	var model_to_use = load("res://Character/BaseCharacter/base_character.tscn").instantiate()
	var character_model: CharacterModel = load("res://Character/CharacterModel.tscn").instantiate()
	character_model.initialize(model_to_use)
	
	var capsule_shape = CapsuleShape3D.new()
	capsule_shape.height = 3.5
	
	var box: PlayerControlBox = PlayerControlBox.new()
	
	initialize(character_model, capsule_shape, box)
	
	var sword: Weapon = load("res://Weapons/Concrete/Swords/test_sword.tscn").instantiate()
	sword.initialize(self)
	#sword.position = Vector3(-0.24, -0.1, 0.037)
	#sword.rotation = Vector3(61.9, 157.2, -137.6)
	var weapon_state_machine = WeaponStateMachine.new()
	var weapon_state = SwordRightHandedIdleState.new()
	weapon_state.initialize(self, weapon_state_machine)
	weapon_state_machine.initialize(self, WeaponStateMachine.HandedNess.Right, weapon_state)
	
	attach_right_hand_weapon(sword, weapon_state_machine)
	
	InputManager.start_game()
	

func process_character():
	if should_equip:
		equip_weapons()
	
	if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.RightAttack):
		if not weapons_equiped:
			should_equip = true
	if InputManager.is_action_just_pressed(Actions.PlayerActionButtons.Interact):
		if weapons_equiped:
			unequip_weapons()
			should_equip = false
