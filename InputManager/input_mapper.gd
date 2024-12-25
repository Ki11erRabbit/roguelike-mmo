extends Node


var map: Dictionary = {
	# Player Actions
	"player_movement": "left_stick",
	"player_aim": "right_stick",
	"player_right_attack": "r1",
	"player_right_strong_attack": "r2",
	"player_left_attack": "l1",
	"player_left_strong_attack": "l2",
	"player_jump": "south",
	"player_parry": "north",
	"player_dash": "west",
	"player_quick_access1": "d_pad_up",
	"player_quick_access2": "d_pad_right",
	"player_quick_access3": "d_pad_down",
	"player_quick_access4": "d_pad_left",
	"player_interact": "east",
	"player_menu": "start",
	"player_map": "select",
	"player_emote_window": "l3",
	"player_quick_chat": "r3",
	# Menu Actions
	"menu_accept": "east",
	"menu_reject": "south",
	"menu_up": ["d_pad_up", "left_stick_up"],
	"menu_down": ["d_pad_down", "left_stick_down"],
	"menu_left": ["d_pad_left", "left_stick_left"],
	"menu_right": ["d_pad_right", "left_stick_right"],
	"menu_search": "north",
	"menu_context_menu": "west",
	"menu_menu": "start",
	"menu_map": "select",
	# Main Menu Actions
	"main_menu_up": ["d_pad_up", "left_stick_up"],
	"main_menu_down": ["d_pad_down", "left_stick_down"],
	"main_menu_left": ["d_pad_left", "left_stick_left"],
	"main_menu_right": ["d_pad_right", "left_stick_right"],
	"main_menu_accept": "east",
	"main_menu_reject": "south",
}


func get_stick_vector(stick: String) -> Vector2:
	var output = Vector2(0,0)
	match map[stick]:
		"left_stick":
			output = Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")
		"right_stick":
			output = Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down")
	return output
	
func is_action_pressed(action: String) -> bool:
	var item = map[action]
	if is_instance_of(item, "Array"):
		return item.map(is_action_pressed).any(func(x): x)
	return Input.is_action_pressed(map[action])

func is_action_just_pressed(action: String) -> bool:
	var item = map[action]
	if is_instance_of(item, "Array"):
		return item.map(is_action_just_pressed).any(func(x): x)
	return Input.is_action_just_pressed(map[action])

func is_action_just_released(action: String) -> bool:
	var item = map[action]
	if is_instance_of(item, "Array"):
		return item.map(is_action_just_released).any(func(x): x)
	return Input.is_action_just_released(map[action])
