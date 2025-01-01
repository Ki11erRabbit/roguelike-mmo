class_name FallingState extends "res://Character/MovementStateMachine/States/character_movement_state.gd"


var fall_time: float

func initialize(character: Character, state_machine: MovementStateMachine, initial_delta = null):
	super(character, state_machine)
	fall_time = initial_delta
	character.play_body_animation("falling")




func in_air(delta: float):
	fall_time += delta

func on_ground(delta: float):
	fall_time += delta
	
	landing()

func landing():
	state_machine.movement_state = LandingState.new()
	state_machine.movement_state.initialize(character, state_machine, fall_time)
	character.land()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
