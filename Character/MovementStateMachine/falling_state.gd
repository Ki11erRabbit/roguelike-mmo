class_name FallingState extends "res://Character/MovementStateMachine/character_movement_state.gd"


var fall_time: float

func initialize(character: Character, current_last_aim: Vector2, initial_delta = null):
	super(character, current_last_aim)
	fall_time = initial_delta
	character.play_body_animation("falling")


func apply_current_state(delta: float):
	process_rotation(delta)
	process_movement()
	process_gravity(delta, self)

func in_air(delta: float):
	fall_time += delta

func on_ground(delta: float):
	fall_time += delta
	
	landing()

func landing():
	character.movement_state = LandingState.new()
	character.movement_state.initialize(character, last_aim, fall_time)
	character.land()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
