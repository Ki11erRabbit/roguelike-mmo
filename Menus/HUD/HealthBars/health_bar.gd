class_name HealthBar extends Control


var bar: ProgressBar



var health_color_steps: Array[ColorStep] = [
	ColorStep.RED_EMPTY,
	ColorStep.RED,
	ColorStep.YELLOW,
	ColorStep.GREEN,
	ColorStep.GREEN_MAX
]

func update_max_health(value: float):
	bar.max_value = value

func update_current_value(value: float):
	bar.value = value

func interpret_color():
	var current_step: ColorStep
	var index: int = 0
	for step in health_color_steps:
		var percentage: float = bar.value / bar.max_value * 100
		if step.point <= percentage:
			current_step = step
		else:
			break
		if index < health_color_steps.size() - 1:
			index += 1
	if current_step == null:
		return
	
	var next_index: int = index + 1
	if next_index >= health_color_steps.size():
		next_index = index
	var next_step: ColorStep = health_color_steps[next_index]
	
	var weight: float = (bar.value / bar.max_value * 100 - current_step.point) / (next_step.point - current_step.point)
	#print(weight)
	
	var new_color: Color = current_step.color
	if current_step.color != next_step.color:
		new_color = current_step.color.lerp(next_step.color, weight)

	bar.get_theme_stylebox("fill").bg_color = new_color
				



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
