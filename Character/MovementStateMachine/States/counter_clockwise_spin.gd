class_name CounterClockwiseSpin extends "res://Character/MovementStateMachine/States/character_movement_state.gd"

var return_state: CharacterMovementState

func initialize(character: Character, state_machine: MovementStateMachine, return_state = null):
	super(character, state_machine)
	self.return_state = return_state
	character.model.animation_finished.connect(spinning_finished)
	character.play_body_animation("counter_clockwise_spin")

func spinning_finished(anim_name: StringName):
	match String(anim_name):
		"counter_clockwise_spin":
			state_machine.movement_state = return_state
			state_machine.movement_state.initialize(character, state_machine)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass