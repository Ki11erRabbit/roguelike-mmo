class_name JumpingState extends "res://Character/BaseCharacter/StateMachine/character_movement_state.gd"

var current_delta = 0.0

func initialize(character: Player, current_last_aim: Vector2, additional = null):
	super(character, current_last_aim)
	

func apply_current_state(delta: float):
	process_gravity(delta,self)
	process_rotation()
	process_movement()

func in_air(delta: float):
	if character.velocity.y < 0.0:
		current_delta = delta
		falling()



func falling():
	character.movement_state = FallingState.new()
	character.movement_state.initialize(character, last_aim, current_delta)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
