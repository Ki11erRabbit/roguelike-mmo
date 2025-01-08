class_name JumpState extends "res://Character/MovementStateMachine/States/character_movement_state.gd"



func initialize(character: Character, state_machine: MovementStateMachine, additional = null):
	super(character, state_machine)
	character.jump()
	character.model.animation_finished.connect(jumping_finished)
	character.play_body_animation("jump")
	


func jumping():
	state_machine.movement_state = JumpingState.new()
	state_machine.movement_state.initialize(character, state_machine)


func jumping_finished(anim_name: StringName) -> void:
	match String(anim_name):
		"jump":
			character.velocity.y += state_machine.JUMP_VELOCITY
			character.model.animation_finished.disconnect(jumping_finished)
			jumping()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
