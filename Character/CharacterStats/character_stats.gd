class_name CharacterStats extends Node

var current_level: int = 1

var max_health: int = 100
var current_health: int = 100

var health_regen_percentage: float = 1
var health_regen_cooldown: float = 5

var strength: int = 10
var speed: float = 0.5

var defense: int


var right_arm_level: int = 1
var right_strength: int = 10
var right_speed: float = 0.5

var left_arm_level: int = 1
var left_strength: int = 10
var left_speed: float = 0.5


func setup_new(level: int, right_level: int, left_level: int, regen_percentage: float, calculator: CharacterCalculator):
	current_level = level
	right_arm_level = right_level
	left_arm_level = left_level
	max_health = calculator.calculate_max_health(level)
	health_regen_percentage = regen_percentage
	strength = calculator.calculate_strength(right_level, left_level)
	speed = calculator.calculate_speed(level)
	right_strength = calculator.calculate_arm_strength(right_level)
	left_strength = calculator.calculate_arm_strength(left_level)
	right_speed = calculator.calculate_arm_speed(right_level)
	left_speed = calculator.calculate_arm_speed(left_level)

func set_defense(value: int):
	defense = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
