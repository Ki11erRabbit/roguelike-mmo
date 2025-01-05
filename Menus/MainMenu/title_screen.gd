extends Control

const Actions = preload("res://InputManager/actions.gd")
const SettingsMenu = preload("res://Menus/MainMenu/Setttings/settings_menu.tscn")

enum SelectedButton { None, Start, Settings, Quit, Server }
@onready
var start_button: BaseButton = $CenterContainer/VBoxContainer/Start
@onready
var settings_button: BaseButton = $CenterContainer/VBoxContainer/Settings
@onready
var quit_button: BaseButton = $CenterContainer/VBoxContainer/Quit
@onready
var server_button: BaseButton = $CenterContainer/VBoxContainer/Server

var current_selected_button: SelectedButton = SelectedButton.None

const COOLDOWN = 0.2
const WAIT_TIME: float = 2
var pressed_time: float = 0.0

var block_input: bool = false

func deselect_buttons():
	current_selected_button = SelectedButton.None
	grab_focus()

func select_start_button():
	current_selected_button = SelectedButton.Start
	start_button.grab_focus()

func activate_start_button():
	Networking.start_client()
	#start_button.button_pressed = true
	#pressed_time = WAIT_TIME
	#get_tree().change_scene_to_file("res://MainScene.tscn")

func select_settings_button():
	current_selected_button = SelectedButton.Settings
	settings_button.grab_focus()

func activate_settings_button():
	settings_button.button_pressed = true
	pressed_time = WAIT_TIME
	start_blocking_input()
	add_child(SettingsMenu.instantiate())

func select_server_button():
	current_selected_button = SelectedButton.Server
	server_button.grab_focus()

func activate_server_button():
	server_button.button_pressed = true
	Networking.start_server()

func select_quit_button():
	current_selected_button = SelectedButton.Quit
	quit_button.grab_focus()

func activate_quit_button():
	quit_button.button_pressed = true
	pressed_time = WAIT_TIME
	get_tree().quit()

func start_blocking_input():
	block_input = true

func stop_blocking_input():
	block_input = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if pressed_time > 0:
		pressed_time -= delta
	elif pressed_time <= 0.0:
		pressed_time = 0
		
	if block_input:
		return
		
	if InputManager.is_action_pressed(Actions.MainMenuActionButtons.Up, COOLDOWN):
		match current_selected_button:
			SelectedButton.None:
				current_selected_button = SelectedButton.Start
				select_start_button()
			SelectedButton.Start:
				current_selected_button = SelectedButton.Quit
				select_quit_button()
			SelectedButton.Settings:
				current_selected_button = SelectedButton.Start
				select_start_button()
			SelectedButton.Server:
				current_selected_button = SelectedButton.Settings
				select_settings_button()
			SelectedButton.Quit:
				current_selected_button = SelectedButton.Server
				select_server_button()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Down, COOLDOWN):
		match current_selected_button:
			SelectedButton.None:
				current_selected_button = SelectedButton.Quit
				select_quit_button()
			SelectedButton.Start:
				current_selected_button = SelectedButton.Settings
				select_settings_button()
			SelectedButton.Settings:
				current_selected_button = SelectedButton.Server
				select_server_button()
			SelectedButton.Server:
				current_selected_button = SelectedButton.Quit
				select_quit_button()
			SelectedButton.Quit:
				current_selected_button = SelectedButton.Start
				select_start_button()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Accept, COOLDOWN):
		match current_selected_button:
			SelectedButton.Start:
				activate_start_button()
			SelectedButton.Settings:
				activate_settings_button()
			SelectedButton.Quit:
				activate_quit_button()
			SelectedButton.Server:
				activate_server_button()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Reject, COOLDOWN):
		current_selected_button = SelectedButton.None
	
	
