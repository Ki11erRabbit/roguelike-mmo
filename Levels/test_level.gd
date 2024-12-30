extends Node

var initialized_player: bool = false
var character: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_model = load("res://Character/BaseCharacter/base_character.tscn").instantiate()
	var character_model = CharacterModel.new()
	character_model.initialize(player_model)
	
	var character = Character.new()
	var capsule_shape = CapsuleShape3D.new()
	capsule_shape.height = 3.5
	# TODO: resize capsule_shape
	
	var box = PLayerControlBox.new()
	character.initialize(character_model, capsule_shape, box)
	character.collision_box.position.y = 1.5
	character.collision_box.position.z = -0.75
	
	var camera = Camera3D.new()
	camera.position.y = 9.405
	camera.rotation.x = -90
	character.add_child(camera)
	
	self.character = character
	add_child(character)
	
	InputManager.start_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not initialized_player:
		character.movement_state.initialize(character, Vector2(0,0), 0.0)
	pass
