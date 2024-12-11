extends CharacterBody2D


const SPEED = 300.0

var attacking = false

var angle_threshold : float = 200.00
var last_angle: float = 0
var total_rotation: float
var angle_array: Array = []
var spinning_clockwise = false
var spinning_anticlockwise = false

@onready
var direction_indicator = $Control/Indicator
@onready
var sword = $Control/Sword
@onready
var sword_swing = $Control/Sword/SpinAttackControl/Sprite2D/Swing
@onready
var sword_stab = $Control/Sword/SpinAttackControl/Sprite2D/Stab
@onready
var sword_spin = $Control/Sword/SpinAttackControl/SpinAttack

func _ready() -> void:
	sword_swing.play("RESET")

func _physics_process(delta: float) -> void:
	if attacking:
		return
	
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_direction.normalized() * SPEED
	
	var aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var angle = aim_direction.angle()
	
	var angle_diff = last_angle - rad_to_deg(angle)
	
	if (angle_diff >= angle_threshold) or (angle_diff <= -angle_threshold):
		pass
	else:
		#angle_array.resize(angle_array.size() + 1)
		angle_array.push_back(angle_diff)
	
	if angle_array.size() > 10:
		var mean = calculate_mean(angle_array)
	
		if mean > -5:
			#print("spinning")
			spinning_anticlockwise = true
		elif mean < 5:
			#print("spinning")
			spinning_clockwise = true
		elif mean <= 10 or mean >= -10:
			reset_bools()
	
	
	if aim_direction.length() == 0.0:
		angle_array.resize(0)
		reset_bools()
	last_angle = rad_to_deg(angle)
	
	
	
	if angle != 0 and not attacking:
		#print(angle)
		var new_angle = deg_to_rad(rad_to_deg(angle) + 90)
		
		direction_indicator.rotation = lerp_angle(direction_indicator.rotation, new_angle, 18 * delta)
		sword.rotation = direction_indicator.rotation
		
	
	if Input.is_action_pressed("light_attack"):
		attacking = true
		if spinning_clockwise:
			sword_spin.play("spin attack")
		elif abs(deg_to_rad(angle_difference(move_direction.angle(), aim_direction.angle())) * 100) < 3 and not move_direction.is_zero_approx():
			sword_stab.play("stab")
		else:
			sword_swing.play("swing")
		return
	
	
	move_and_slide()

func disable_attacking(anim_name: StringName = ""):
	attacking = false
	reset_bools()
	angle_array.resize(0)


func calculate_mean(array: Array):
	var sum = 0
	for x in array:
		sum += x
	
	return sum / (array.size() - 1)

func reset_bools():
	spinning_anticlockwise = false
	spinning_clockwise = false
