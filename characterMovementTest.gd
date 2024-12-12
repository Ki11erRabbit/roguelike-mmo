extends CharacterBody2D


const SPEED = 300.0

var attacking = false
var pressed_once = false
var held_down = false
var time_held_down: float = 0.0
var locked_in_direction: Vector2 = Vector2(0,0)
var stabbing = false

var angle_threshold : float = deg_to_rad(200.00)
var last_angle: float = 0
var total_rotation: float
var angle_array: Array = []
var spinning_clockwise = false
var spinning_anticlockwise = false
var spin_counter: float = 0.0

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
		var modifier = 1
		if spinning_anticlockwise and spinning_clockwise:
			modifier = 2
		elif stabbing:
			modifier = 2
		velocity = locked_in_direction * SPEED * modifier
		move_and_slide()
		return
	
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_direction * SPEED
	
	var aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var angle = aim_direction.angle()
	
	var angle_diff = angle_difference(last_angle, angle)
	
	if (angle_diff >= angle_threshold) or (angle_diff <= -angle_threshold):
		pass
	else:
		#angle_array.resize(angle_array.size() + 1)
		#print("angle diff")
		#print(deg_to_rad(angle_diff))
		angle_array.push_back(angle_diff)
	
	if angle_array.size() > 20:
		var mean = calculate_mean(angle_array)
		
		if mean <= -8:
			#print("spinning")
			spinning_anticlockwise = true
			spin_counter += delta
		elif mean >= 8:
			print("spinning")
			print(mean)
			spinning_clockwise = true
			spin_counter += delta
		elif (mean <= 8 or mean >= -8) and spin_counter >= 1.0:
			reset_bools()
			spin_counter = 0.0
		angle_array.resize(0)
	
	
	#if aim_direction.length() == 0.0:
	#	reset_bools()
	last_angle = angle
	
	
	
	if angle != 0 and not attacking:
		#print(angle)
		var new_angle = deg_to_rad(rad_to_deg(angle) + 90)
		
		direction_indicator.rotation = lerp_angle(direction_indicator.rotation, new_angle, 18 * delta)
		sword.rotation = direction_indicator.rotation
		
	if Input.is_action_pressed("light_attack"):
		pressed_once = true
		time_held_down += delta
	elif pressed_once:
		pressed_once = false
		
		
	
	if Input.is_action_just_released("light_attack"):
		attacking = true
		if spinning_clockwise:
			sword_spin.play("spin attack")
		elif abs(deg_to_rad(angle_difference(move_direction.angle(), aim_direction.angle())) * 100) < 3 and not move_direction.is_zero_approx() and aim_direction != Vector2(0, 0):
			sword_stab.play("stab")
			stabbing = true
		else:
			sword_swing.play("swing")
			
		if time_held_down >= 1.0:
			time_held_down = 0
			locked_in_direction = move_direction
		return
	
	
	move_and_slide()

func disable_attacking(anim_name: StringName = ""):
	attacking = false
	stabbing = false
	reset_bools()
	angle_array.resize(0)
	locked_in_direction = Vector2(0, 0)
	spin_counter = 0.0


func calculate_mean(array: Array):
	var sum = 0
	for x in array:
		sum += rad_to_deg(x)
	
	return sum / (array.size() - 1)

func reset_bools():
	spinning_anticlockwise = false
	spinning_clockwise = false
