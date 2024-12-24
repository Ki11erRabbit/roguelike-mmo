extends Node3D


@onready
var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

func rotate_left():
	state_machine.travel("rotate_left")

func rotate_right():
	state_machine.travel("rotate_right")
	
func stop_rotating():
	state_machine.travel("Idle")


func start_standing():
	state_machine.travel("Idle")

func start_walking():
	state_machine.travel("walk")

func start_running():
	state_machine.travel("run")

func start_backstepping():
	state_machine.travel("backstep")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
