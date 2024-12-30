class_name JumpState extends "res://Character/MovementStateMachine/character_movement_state.gd"



func initialize(character: Character, current_last_aim: Vector2, additional = null):
	super(character, current_last_aim)
	character.model.animation_finished.connect(jumping_finished)
	character.play_body_animation("jump")
	

func apply_current_state(delta: float):
	pass
	
	

func jumping():
	character.movement_state = JumpingState.new()
	character.movement_state.initialize(character, last_aim)


func jumping_finished(anim_name: StringName) -> void:
	match String(anim_name):
		"jump":
			character.velocity.y += JUMP_VELOCITY
			jumping()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
