class_name ColorStep extends Node
@export
var point: int
@export
var color: Color

static var GREEN_MAX: ColorStep = ColorStep.new().green_max()
static var GREEN: ColorStep = ColorStep.new().green()
static var YELLOW: ColorStep = ColorStep.new().yellow()
static var RED: ColorStep = ColorStep.new().red()
static var RED_EMPTY: ColorStep = ColorStep.new().red_empty()


func initialize(starting_point: int, color: Color):
	self.point = starting_point
	self.color = color

func green() -> ColorStep:
	self.initialize(50, Color.GREEN)
	return self

func green_max() -> ColorStep:
	self.initialize(100, Color.GREEN)
	return self

func yellow() -> ColorStep:
	self.initialize(30, Color.YELLOW)
	return self

func red() -> ColorStep:
	self.initialize(15, Color.DARK_RED)
	return self

func red_empty() -> ColorStep:
	self.initialize(0, Color.DARK_RED)
	return self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
