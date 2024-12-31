class_name CounterClockwiseSpin extends "res://Character/MovementStateMachine/character_movement_state.gd"

var return_state: CharacterMovementState

func initialize(character: Character, current_last_aim: Vector2, return_state = null):
	super(character, current_last_aim)
	self.return_state = return_state
	character.model.animation_finished.connect(spinning_finished)
	character.play_body_animation("counter_clockwise_spin")

func apply_current_state(delta: float):
	pass

func spinning_finished(anim_name: StringName):
	match String(anim_name):
		"counter_clockwise_spin":
			character.movement_state = return_state
			character.movement_state.initialize(character, last_aim)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
