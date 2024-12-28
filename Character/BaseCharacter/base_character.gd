extends Node3D


@onready
var body_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/Body/playback"]
#@onready
#var body_b_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/BodyB/playback"]
@onready
var left_arm_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/LeftArm/playback"]
@onready
var right_arm_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/RightArm/playback"]




func unequip():
	$AnimationTree["parameters/LeftArmOneShot/request"] = 2
	$AnimationTree["parameters/RightArmOneShot/request"] = 2

func equip_right_handed_sword():
	$AnimationTree["parameters/RightArmOneShot/request"]= 1
	
func body_travel(state: String):
	body_state_machine.travel(state)
	#body_b_state_machine.travel(state)

func right_hand_reset():
	right_arm_state_machine.travel("sword_right_hand_idle")
func right_hand_slash1():
	right_arm_state_machine.travel("sword_right_hand_slash1")
func right_hand_slash2():
	right_arm_state_machine.travel("sword_right_hand_slash2")
func right_hand_thrust():
	right_arm_state_machine.travel("sword_right_hand_thrust")

func rotate_left():
	pass

func rotate_right():
	pass

var standing_counter = 0
func start_standing():
	body_travel("idle")
	#if state_machine.get_current_node() != "idle":
		#standing_counter += 1
		#if standing_counter > 1:
			#return
		#state_machine.travel("idle")

func start_walking():
	body_travel("walk")
	#state_machine.travel("walk")

func start_running():
	body_travel("run")
	#state_machine.travel("run")

func start_backstepping():
	body_travel("backstep")
	#state_machine.travel("backstep")

func jump():
	body_travel("jump")
	#state_machine.travel("jump")


func start_falling():
	body_travel("falling")
	#state_machine.travel("falling")

func start_long_falling():
	
	body_travel("long_falling")
	#state_machine.travel("long_falling")

func short_fall_landing():
	
	body_travel("short_fall_landing")
	#state_machine.travel("short_fall_landing")

func medium_fall_landing():
	
	body_travel("medium_fall_landing")
	#state_machine.travel("medium_fall_landing")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unequip()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(state_machine.get_current_node())
	standing_counter = 0
	pass
