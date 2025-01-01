class_name LandingState extends "res://Character/MovementStateMachine/States/character_movement_state.gd"


func initialize(character: Character, state_machine: MovementStateMachine, fall_time = null):
	super(character, state_machine)
	character.model.animation_finished.connect(landing_finished)
	if fall_time < 8 and fall_time > 0:
		character.play_body_animation("short_fall_landing")
	elif fall_time >= 8 and fall_time < 20:
		character.play_body_animation("medium_fall_landing")


func stand():
	state_machine.movement_state = StandingState.new()
	state_machine.movement_state.initialize(character, state_machine)
	character.ground()

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
