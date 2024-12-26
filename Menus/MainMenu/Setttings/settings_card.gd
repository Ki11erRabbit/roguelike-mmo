class_name SettingsCard extends Control


@onready
var item_container = $ScrollContainer/ItemContainer
@export
var items: Array = []
var current_item: int = -1
var added_children: bool = false

func initialize(items: Array):
	self.items = items
	print("creating")

func select_next_item():
	if current_item < 0:
		current_item = item_container.get_children().size() - 1
		return
	
	current_item = (current_item + 1) % item_container.get_children().size()

func select_previous_item():
	if current_item < 0:
		current_item = 0
		return
	
	current_item = (current_item - 1) % item_container.get_children().size()

func select_current_items_next_item():
	item_container.get_children()[current_item].select_next_item()


func select_current_items_previous_item():
	item_container.get_children()[current_item].select_previous_item()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_children()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_children():
	items.reverse()
	for i in range(0, items.size()):
		item_container.add_child(items.pop_back())
	added_children = true
	print("added children")
	print(items.size())
	print(item_container.get_children().size())
