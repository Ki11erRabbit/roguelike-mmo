class_name CharacterCalculator extends Node

func calculate_max_health(level: int) -> int:
	if level == 1000:
		return 100_000_000
	elif level <= 65:
		return int(floor(6.37389 * level ** 2 + 46.5109 * level + 47.1211))
	elif level >= 980:
		return int(floor(175.39 * level ** 2 - 75390.3 * level - 118.077))
	else:
		return int(floor(109.1 * level ** 2 - 10692.3 * level + 261018))

func calculate_health_regen(level: int) -> int:
	var max_hp = calculate_max_health(level)
	return int(ceil(max_hp / 100))

func calculate_strength(right_level: int, left_level: int) -> int:
	return calculate_arm_strength(right_level) + calculate_arm_strength(left_level)

func calculate_speed(level: int) -> float:
	return 0.0015015 * level + 0.498498
	#return 0.001001 * level + 0.998999

func calculate_arm_exp_needed(level: int) -> int:
	level += 1
	if level > 1000:
		return -1
	else:
		return int(floor(4.95545 * level ** 2 + 44.5269 * level + 24.3562))

func calculate_arm_strength(level: int) -> int:
	if level == 1000:
		return 3_000
	elif level == 1:
		return 10
	elif level >= 700:
		return int(floor(1.33333 * level + 1666.67))
	else:
		return int(floor(-0.00402377 * level ** 2 + 6.52044 * level + 3.86433))
		#return int(floor(-0.00204871 * level ** 2 + 7.04635 * level + 4.13668))

func calculate_arm_speed(level: int) -> float:
	return calculate_speed(level)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
