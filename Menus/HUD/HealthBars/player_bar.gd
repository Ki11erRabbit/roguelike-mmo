extends Control

signal health_hit_zero
signal grace_period_ended

@onready
var timer: Timer = $Timer
var started_timer: bool = false
const GRACE_PERIOD: int = 10

@onready
var bar: ProgressBar = $ProgressBar

@export
var max_health: float = 0

@export
var current_value: float = 0
@export
var damage: float = 0

@export
var drain_per_second: float = 80 / 60:
	set(value):
		drain_per_second = value / 60

@export
var healing: float = 0

@export
var fill_per_second: float = 160 / 60:
	set(value):
		drain_per_second = value / 60


var health_color_steps: Array[ColorStep] = [
	ColorStep.RED_EMPTY,
	ColorStep.RED,
	ColorStep.YELLOW,
	ColorStep.GREEN,
	ColorStep.GREEN_MAX
]

func add_damage(amount: int):
	damage += amount

func add_healing(amount: int):
	healing += amount

func set_health(max: int, current: int):
	max_health = max
	if current > 0:
		current_value = current
	
	bar.max_value = max_health
	bar.value = current_value
	
func interpret_color():
	var current_step: ColorStep
	var index: int = 0
	for step in health_color_steps:
		var percentage: float = current_value / max_health * 100
		if step.point <= percentage:
			current_step = step
		else:
			break
		if index < health_color_steps.size() - 1:
			index += 1
	
	var next_index: int = index + 1
	if next_index >= health_color_steps.size():
		next_index = index
	var next_step: ColorStep = health_color_steps[next_index]
	
	var weight: float = (current_value / max_health * 100 - current_step.point) / (next_step.point - current_step.point)
	#print(weight)
	
	var new_color: Color = current_step.color
	if current_step.color != next_step.color:
		new_color = current_step.color.lerp(next_step.color, weight)

	bar.get_theme_stylebox("fill").bg_color = new_color
				

func start_timer():
	if not started_timer:
		started_timer = true
		timer.start()

func reset_timer():
	if started_timer:
		started_timer = false
		timer.stop()
		timer.wait_time = GRACE_PERIOD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bar.max_value = max_health
	bar.value = current_value
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if damage > 0:
		if damage - drain_per_second < 0:
			current_value -= damage
		else:
			damage -= drain_per_second
			current_value -= drain_per_second
	
	if damage <= 0:
		damage = 0
		current_value = ceil(current_value)
	
	if healing > 0:
		if healing - fill_per_second < 0:
			current_value += healing
		else:
			healing -= fill_per_second
			current_value += fill_per_second
	
	if healing <= 0:
		healing = 0
		current_value = ceil(current_value)
	
	if current_value <= 0:
		current_value = 0
		emit_signal("health_hit_zero")
		$Timer.start()
	
	if current_value >= max_health:
		current_value = max_health
	bar.value = current_value
	
	
	interpret_color()



func _on_timer_timeout() -> void:
	emit_signal("grace_period_ended")
