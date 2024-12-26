extends Control

const Actions = preload("res://InputManager/actions.gd")

enum SelectedButton { None, Start, Settings, Quit }
@onready
var start_button: BaseButton = $CenterContainer/VBoxContainer/Start
@onready
var settings_button: BaseButton = $CenterContainer/VBoxContainer/Settings
@onready
var quit_button: BaseButton = $CenterContainer/VBoxContainer/Quit

var current_selected_button: SelectedButton = SelectedButton.None

const COOLDOWN = 0.2

func deselect_buttons():
	current_selected_button = SelectedButton.None
	grab_focus()

func select_start_button():
	current_selected_button = SelectedButton.Start
	start_button.grab_focus()

func activate_start_button():
	pass

func select_settings_button():
	current_selected_button = SelectedButton.Settings
	settings_button.grab_focus()

func activate_settings_button():
	pass

func select_quit_button():
	current_selected_button = SelectedButton.Quit
	quit_button.grab_focus()

func activate_quit_button():
	get_tree().quit()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
		
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
			SelectedButton.Quit:
				current_selected_button = SelectedButton.Settings
				select_settings_button()
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Down, COOLDOWN):
		match current_selected_button:
			SelectedButton.None:
				current_selected_button = SelectedButton.Quit
				select_quit_button()
			SelectedButton.Start:
				current_selected_button = SelectedButton.Settings
				select_settings_button()
			SelectedButton.Settings:
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
	elif InputManager.is_action_pressed(Actions.MainMenuActionButtons.Reject, COOLDOWN):
		current_selected_button = SelectedButton.None
	
	
