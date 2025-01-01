class_name StandingState extends "res://Character/MovementStateMachine/States/character_movement_state.gd"

var is_rotating: bool = false

func initialize(character: Character, state_machine: MovementStateMachine, additional = null):
	super(character, state_machine)
	character.play_body_animation("idle")
	


func apply_current_state(delta: float, control_box: ControlBox, rotation_triple: Array):
	if control_box == null:
		return
	var pair: Array = rotation_triple
	var is_rotating_new = pair[0]
	var is_rotating_clockwise = pair[1]
	if is_rotating_new != is_rotating:
		is_rotating = is_rotating_new
		if is_rotating:
			if is_rotating_clockwise:
				character.play_body_animation("rotate_right")
			else:
				character.play_body_animation("rotate_left")
		else:
			character.play_body_animation("idle")
	
func move():
	state_machine.movement_state = MovingState.new()
	state_machine.movement_state.initialize(character, state_machine)

func use_custom_movement() -> bool:
	return true

func custom_movement(control_box: ControlBox):
	move()

func falling():
	state_machine.movement_state = FallingState.new()
	state_machine.movement_state.initialize(character, state_machine, 0.0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
