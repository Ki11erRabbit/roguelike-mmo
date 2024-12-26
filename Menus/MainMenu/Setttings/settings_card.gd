class_name SettingsCard extends Control


@onready
var item_container = $ScrollContainer/ItemContainer
@export
var items: Array = []
var current_item: int = -1
var added_children: bool = false
var current_child_selection: int = 0
@onready
var header = $InfoBox/Header
@onready
var description = $InfoBox/Description


func initialize(items: Array):
	self.items = items
	print("creating")

func select_next_item() -> int:
	if current_item < 0:
		current_item = item_container.get_children().size() - 1
		display_current_items_text()
		return current_item
	
	current_item = (current_item + 1) % item_container.get_children().size()
	select_current_items_particular_item(current_child_selection)
	display_current_items_text()
	return current_item

func select_previous_item() -> int:
	if current_item < 0:
		current_item = 0
		display_current_items_text()
		return current_item
	
	current_item = (current_item - 1) % item_container.get_children().size()
	select_current_items_particular_item(current_child_selection)
	display_current_items_text()
	return current_item

func select_current_items_next_item() -> int:
	current_child_selection = item_container.get_children()[current_item].select_next_item()
	return current_child_selection


func select_current_items_previous_item() -> int:
	current_child_selection = item_container.get_children()[current_item].select_previous_item()
	return current_child_selection

func select_current_items_particular_item(index: int):
	item_container.get_children()[current_item].select_particular_item(index)

func activate_current_item():
	item_container.get_children()[current_item].activate_current_item()

func display_current_items_text():
	header.text = item_container.get_child(current_item).header
	description.text = item_container.get_child(current_item).description

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
