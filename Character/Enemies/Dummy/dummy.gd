extends "res://Character/character.gd"



func ready_character():
	
	stats = CharacterStats.new()
	stats.setup_new(1, 1, 1, 5, HumanCalculator.new())
	
	
	var model_to_use = load("res://Character/BaseCharacter/base_character.tscn").instantiate()
	var character_model: CharacterModel = load("res://Character/CharacterModel.tscn").instantiate()
	character_model.initialize(model_to_use)
	
	var capsule_shape = collision_box.shape
	
	var box: ControlBox = ControlBox.new()
	
	initialize(character_model, capsule_shape, box)
	
	
	

	
