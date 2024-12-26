extends Control

const Actions = preload("res://InputManager/actions.gd")
const SettingsCard = preload("res://Menus/MainMenu/Setttings/settings_card.tscn")
const SettingsItem = preload("res://Menus/MainMenu/Setttings/settings_item.tscn")
const KeybindButton = preload("res://Menus/MainMenu/Setttings/keybind_change_button.tscn")

const COOLDOWN = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: add way to change sticks
	var settings_items = [
		# Player Actions
		create_setting_item("player_right_attack", "Light Attack", ""),
		create_setting_item("player_right_strong_attack", "player_right_strong_attack", ""),
		create_setting_item("player_left_attack", "player_left_attack", ""),
		create_setting_item("player_left_strong_attack", "player_left_strong_attack", ""),
		create_setting_item("player_jump", "player_jump", ""),
		create_setting_item("player_parry", "player_parry", ""),
		create_setting_item("player_dash", "player_dash", ""),
		create_setting_item("player_quick_access1", "player_quick_access1", ""),
		create_setting_item("player_quick_access2", "player_quick_access2", ""),
		create_setting_item("player_quick_access3", "player_quick_access3", ""),
		create_setting_item("player_quick_access4", "player_quick_access4", ""),
		create_setting_item("player_interact", "player_interact", ""),
		create_setting_item("player_menu", "player_map", ""),
		create_setting_item("player_emote_window", "player_emote_window", ""),
		create_setting_item("player_quick_chat", "player_quick_chat", ""),
		# Menu Actions
		create_setting_item("menu_accept", "menu_accept", ""),
		create_setting_item("menu_reject", "menu_reject", ""),
		create_setting_item("menu_up", "menu_up", ""),
		create_setting_item("menu_down", "menu_down", ""),
		create_setting_item("menu_left", "menu_left", ""),
		create_setting_item("menu_right", "menu_right", ""),
		create_setting_item("menu_search", "menu_search", ""),
		create_setting_item("menu_context_menu", "menu_context_menu", ""),
		create_setting_item("menu_menu", "menu_menu", ""),
		create_setting_item("menu_map", "menu_map", ""),
		# Main Menu Actions
		create_setting_item("main_menu_up", "main_menu_up", ""),
		create_setting_item("main_menu_down", "main_menu_down", ""),
		create_setting_item("main_menu_left", "main_menu_left", ""),
		create_setting_item("main_menu_right", "main_menu_right", ""),
		create_setting_item("main_menu_accept", "main_menu_accept", ""),
		create_setting_item("main_menu_reject", "main_menu_reject", ""),
		
	]
	
	
	var settings_card: SettingsCard = SettingsCard.instantiate()
	settings_card.initialize(settings_items)
	
	$CardSlot.add_child(settings_card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if InputManager.is_action_pressed(Actions.MainMenuActionButtons.Up, COOLDOWN):
		$CardSlot.get_child(0).select_previous_item()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Down, COOLDOWN):
		$CardSlot.get_child(0).select_next_item()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Right, COOLDOWN):
		$CardSlot.get_child(0).select_current_items_next_item()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Left, COOLDOWN):
		$CardSlot.get_child(0).select_current_items_previous_item()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Accept, COOLDOWN):
		$CardSlot.get_child(0).activate_current_item()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Reject, COOLDOWN):
		get_parent().stop_blocking_input()
		self.queue_free()

func create_setting_item(binding: String, header: String, description: String):
	var bindings = InputMapper.get_binding(binding)
	var label = Label.new()
	label.text = binding
	label.custom_minimum_size.x = 200
	var items = [label]
	if bindings is String:
		var item = KeybindButton.instantiate()
		item.initialize(binding, bindings, 0)
		items.append(item)
		item = KeybindButton.instantiate()
		item.initialize(binding, "", 1)
		items.append(item)
	else:
		var index = 0
		for b in bindings:
			var item = KeybindButton.instantiate()
			item.initialize(binding, b, index)
			items.append(item)
			index += 1
	
	var out = SettingsItem.instantiate()
	out.initialize(header, description, items, {0: 1})
	return out
	
	
