class_name MovementStateMachine extends Node

var character: Character
var movement_state: CharacterMovementState

var last_aim: Vector2

const X_ROTATION_AMOUNT: float = -15
# Determines the angle that allows for playing the rotation animation
const ROTATION_ANGLE_LIMIT: float = 10

const SPEED = 5

const JUMP_VELOCITY = 10

var disable_input: bool = false
var disable_rotation: bool = false
var disable_movement: bool = false

var disable_gravity: bool = false

func initialize(character: Character):
	self.character = character
	self.movement_state = StandingState.new()
	self.movement_state.initialize(character, self)

func process_state(delta: float):
	#print(movement_state.get_script().resource_path)
	
	var control_box: ControlBox = null
	if disable_input:
		control_box = null
	else:
		control_box = character.control_box
	
	if movement_state.process_movement_buttons(delta, control_box, movement_state):
		control_box = null
	
	
	var triple: Array = [false, false, last_aim]
	
	if not disable_rotation:
		triple = movement_state.process_rotation(delta, control_box,last_aim)
		last_aim = triple[2]
	
	if not disable_movement:
		movement_state.process_movement(delta, control_box, movement_state)
	
	if not disable_gravity:
		movement_state.process_gravity(delta, movement_state)
	
	
	movement_state.apply_current_state(delta, control_box, triple)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
