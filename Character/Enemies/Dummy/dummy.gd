extends "res://Character/character.gd"

var on_server: bool = false

func ready_character():
	
	stats = CharacterStats.new()
	stats.setup_new(1, 1, 1, 5, HumanCalculator.new())
	
	
	var model_to_use = load("res://Character/BaseCharacter/base_character.tscn").instantiate()
	var character_model: CharacterModel = load("res://Character/CharacterModel.tscn").instantiate()
	character_model.initialize(model_to_use)
	
	var capsule_shape = collision_box.shape
	
	var box: ControlBox = $AiControlBox
	$TestAi.initialize(on_server)
	
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
	equip_weapons()
	
func process_character(delta: float):
	$TestAi.process_ai(delta, self)
	
	return false
	

	
func weapon_collided(weapon: Weapon):
	$TestAi.took_damage(weapon.wielder)
	pass
