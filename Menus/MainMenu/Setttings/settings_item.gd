class_name SettingsItem extends Control

@export
var header: String = "":
	get():
		return header
@export
var description: String = "":
	get():
		return description

@export
var items: Array = []
@export
var skip_items: Dictionary = {}

@onready
var container = $HBoxContainer

var current_item: int = -1

func initialize(header: String, description: String, items: Array, skip_items: Dictionary):
	self.header = header
	self.description = description
	self.items = items
	self.skip_items = skip_items

func select_next_item():
	if current_item < 0:
		current_item = container.get_children().size() - 1
	else:
		current_item = (current_item + 1) % container.get_children().size()
	skip_to_next_item(1)
	container.get_child(current_item).grab_focus()
	

func select_previous_item():
	if current_item < 0:
		current_item = 0
	else:
		current_item = (current_item - 1) % container.get_children().size()
	skip_to_next_item(-1)
	container.get_child(current_item).grab_focus()

func skip_to_next_item(right: bool):
	var direction: int = 0
	# making sure we only go by one step
	if right:
		direction = 1
	else:
		direction = -1
	assert(direction != 0, "Direction for skip_to_next_item needs to be non-zero")
	
	while skip_items.get(current_item) != null:
		current_item += direction

func activate_current_item():
	container.get_child(current_item).activate_item()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items.reverse()
	for _i in range(0, items.size()):
		container.add_child(items.pop_back())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
