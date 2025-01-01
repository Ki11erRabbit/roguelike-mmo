class_name JumpingState extends "res://Character/MovementStateMachine/States/character_movement_state.gd"

var current_delta = 0.0

func initialize(character: Character, state_machine: MovementStateMachine, additional = null):
	super(character, state_machine)


func in_air(delta: float):
	if character.velocity.y < 0.0:
		current_delta = delta
		falling()



func falling():
	state_machine.movement_state = FallingState.new()
	state_machine.movement_state.initialize(character, state_machine, current_delta)
	character.fall()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
