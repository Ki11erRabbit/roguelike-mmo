class_name TestAi extends "res://Character/AI/ai.gd"

const Actions = preload("res://InputManager/actions.gd")

const MAX_ATTACK_TIME: float = 1.0
var attack_time: float = MAX_ATTACK_TIME
var attacking: bool = false

func process_ai(delta: float, character: Character) -> void:
	if attack_time != MAX_ATTACK_TIME:
		attack_time -= delta
	if attack_time <= 0.0:
		attack_time = MAX_ATTACK_TIME
	elif attack_time != MAX_ATTACK_TIME:
		reset_aim_vec()
		reset_movement_vec()
		return
	else:
		attacking = false
		control_box.release_button(Actions.PlayerActionButtons.RightAttack)
	var target: AITarget = get_next_target()
	if target == null:
		reset_aim_vec()
		reset_movement_vec()
		return
	
	var target_character: Character = target.target
	var target_position: Vector3 = target_character.global_position
	var character_position: Vector3 = character.global_position
	
	var position_difference: Vector3 = target_position - character_position
	var normalized_diff: Vector3 = position_difference.normalized()
	normalized_diff /= 5
	normalized_diff *= 4
	
	if character_position.distance_to(target_position) <= 3.5:
		normalized_diff = normalized_diff / 6
		normalized_diff *= 4
	
	if character_position.distance_to(target_position) <= 2:
		print("attacking")
		attacking = true
		attack_time -= delta
		control_box.press_button(Actions.PlayerActionButtons.RightAttack)
		reset_movement_vec()
	
	control_box.current_movement_vec = Vector2(normalized_diff.x, normalized_diff.z)
	
	var target_point: Vector2 = Vector2(target_position.x, target_position.z)
	var character_point: Vector2 = Vector2(character_position.x, character_position.z)
	
	var angle: float = character_point.angle_to_point(target_point) + deg_to_rad(90)
	
	var aim_vec: Vector2 = Vector2.UP.rotated(angle)
	
	control_box.current_aim_vec = aim_vec

func reset_movement_vec():
	control_box.current_movement_vec = Vector2(0,0)

func reset_aim_vec():
	control_box.current_aim_vec = Vector2(0,0)
