extends Node

var initialized_player: bool = false
var initialized_weapon: bool = false
var character: Character
var sword: Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var player_model = load("res://Character/BaseCharacter/base_character.tscn").instantiate()
	#var character_model = CharacterModel.new()
	#character_model.initialize(player_model)
	#
	#var character = load("res://Character/character.tscn").instantiate()
	#var capsule_shape = CapsuleShape3D.new()
	#capsule_shape.height = 3.5
	#
	#var box = PLayerControlBox.new()
	#character.initialize(character_model, capsule_shape, box)
	#character.collision_box.position.y = 1.5
	#character.collision_box.position.z = -0.75
	#
	#var camera = Camera3D.new()
	#camera.position.y = 9.405
	#camera.rotation.x = -90
	#character.add_child(camera)
	#
	#sword = load("res://Weapons/Concrete/Swords/test_sword.tscn").instantiate()
	#
	#sword._ready()
	#
	#self.character = character
	#add_child(character)
	
	#InputManager.start_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if not initialized_player:
		#character.movement_state.initialize(character, Vector2(0,0), 0.0)
		#
		#
		#initialized_player = true
	#elif not initialized_weapon:
		#initialized_weapon = true
		#
		#sword.position = Vector3(-0.24, -0.1, 0.037)
		#sword.rotation = Vector3(61.9, 157.2, -137.6)
		#
		#var weapon_state_machine = WeaponStateMachine.new()
		#var weapon_state = SwordRightHandedIdleState.new()
		#weapon_state.initialize(character, weapon_state_machine)
		#weapon_state_machine.initialize(character, WeaponStateMachine.HandedNess.Right, weapon_state)
		#
		#character.attach_right_hand_weapon(sword, weapon_state_machine)
	pass
