class_name StandingState extends "res://Character/MovementStateMachine/character_movement_state.gd"

var is_rotating: bool = false

func initialize(character: Character, current_last_aim: Vector2, additional = null):
	super(character, current_last_aim)
	character.play_body_animation("idle")
	


func apply_current_state(delta: float):
	var pair: Array[bool] = process_rotation(delta)
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

	process_gravity(delta, self)
	
	if process_movement_buttons(self):
		return
	process_movement(self)
	
func move():
	character.movement_state = MovingState.new()
	character.movement_state.initialize(character, last_aim)

func custom_movement():
	move()

func falling():
	character.movement_state = FallingState.new()
	character.movement_state.initialize(character, last_aim, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
