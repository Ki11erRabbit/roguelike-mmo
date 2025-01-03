class_name CombatCalculator extends Node


func calculate_damage_done(weapon: WeaponStats, attacker: CharacterStats, defender: CharacterStats) -> int:
	var weapon_damage = weapon.attack
	
	var weight_modifier: float = log(weapon.weight)
	#var strength_modifier: float
	#match handed:
		#"left":
			#strength_modifier = log(attacker.left_strength) / log(10)
		#"right":
			#strength_modifier = log(attacker.right_strength) / log(10)
		#"both":
			#var strength: float = attacker.left_strength / 2 + attacker.right_strength / 2
			#strength_modifier = log(strength) / log(10)
	
	weapon_damage *= weight_modifier #* strength_modifier
	
	const e_constant: float = 2.71828
	
	return int(floor(weapon_damage - defender.defense * e_constant))

func calculate_attack_speed_modifier(weapon: WeaponStats, attacker: CharacterStats, hand: String) -> float:
	var weight: int = weapon.weight
	var strength: float
	var speed: float
	match hand:
		"right":
			strength = attacker.right_strength
			speed = attacker.right_speed
		"left":
			strength = attacker.left_strength
			speed = attacker.left_speed
		"both":
			strength = attacker.left_strength / 2 + attacker.right_strength / 2
			speed = attacker.left_speed / 2 + attacker.right_speed / 2
	
	var modifier: float = strength / weight
	
	return speed / modifier



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
