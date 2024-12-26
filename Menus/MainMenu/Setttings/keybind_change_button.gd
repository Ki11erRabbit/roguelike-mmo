class_name KeyBindChangeButton extends Button

@export
var button_to_change: String = ""
@export
var binding: String = ""
@export
var variant: int = 0
var accepting_input: bool = false

func initialize(button_name: String, binding: String, variant: int):
	self.button_to_change = button_name
	self.binding = binding
	self.variant = variant
	self.text = self.binding

func _ready() -> void:
	text = binding

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not accepting_input:
		return
	
	var set_input: bool = false
	
	set_input = set_input or check_key("d_pad_down")
	set_input = set_input or check_key("d_pad_left")
	set_input = set_input or check_key("d_pad_up")
	set_input = set_input or check_key("d_pad_right")
	set_input = set_input or check_key("north")
	set_input = set_input or check_key("south")
	set_input = set_input or check_key("east")
	set_input = set_input or check_key("west")
	set_input = set_input or check_key("l1")
	set_input = set_input or check_key("r1")
	set_input = set_input or check_key("l2")
	set_input = set_input or check_key("r2")
	set_input = set_input or check_key("l3")
	set_input = set_input or check_key("r3")
	set_input = set_input or check_key("start")
	set_input = set_input or check_key("select")
	set_input = set_input or check_key("left_stick_down")
	set_input = set_input or check_key("left_stick_left")
	set_input = set_input or check_key("left_stick_right")
	set_input = set_input or check_key("left_stick_up")
	set_input = set_input or check_key("right_stick_down")
	set_input = set_input or check_key("right_stick_left")
	set_input = set_input or check_key("right_stick_right")
	set_input = set_input or check_key("right_stick_up")
	
	if set_input:
		accepting_input = false
		InputManager.enable_input()

func check_key(key: String) -> bool:
	if Input.is_action_just_pressed(key):
		InputMapper.change_binding(button_to_change, key, variant)
		binding = key
		text = key
		return true
	return false

func _on_pressed() -> void:
	text = "Waiting on button press"
	accepting_input = true
	InputManager.disable_input()
