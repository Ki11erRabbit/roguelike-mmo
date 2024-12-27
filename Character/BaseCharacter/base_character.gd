extends Node3D


@onready
var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

func rotate_left():
	state_machine.travel("rotate_left")

func rotate_right():
	state_machine.travel("rotate_right")

var standing_counter = 0
func start_standing():
	if state_machine.get_current_node() != "Idle":
		standing_counter += 1
		if standing_counter > 1:
			return
		state_machine.travel("Idle")

func start_walking():
	state_machine.travel("walk")

func start_running():
	state_machine.travel("run")

func start_backstepping():
	state_machine.travel("backstep")

func jump():
	state_machine.travel("jump")

func start_falling():
	state_machine.travel("falling")

func short_fall_landing():
	state_machine.travel("short_fall_landing")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(state_machine.get_current_node())
	standing_counter = 0
	pass
