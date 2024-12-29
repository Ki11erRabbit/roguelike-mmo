class_name LandingState extends "res://Character/BaseCharacter/StateMachine/character_movement_state.gd"


func initialize(character: Player, current_last_aim: Vector2, fall_time = null):
	super(character, current_last_aim)
	character.model.animation_finished.connect(landing_finished)
	if fall_time < 8 and fall_time > 0:
		character.model.short_fall_landing()
	elif fall_time >= 8 and fall_time < 20:
		character.model.medium_fall_landing()

func apply_current_state(delta: float):
	
	process_gravity(delta, self)

func stand():
	character.movement_state = StandingState.new()
	character.movement_state.initialize(character, last_aim)

func landing_finished(anim_name: StringName) -> void:
	match String(anim_name):
		"short_fall_landing":
			stand()
		"medium_fall_landing":
			stand()
		"long_fall_landing":
			stand()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
