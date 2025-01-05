extends Node


enum PlayerActionButtons { 
	RightAttack, RightStrongAttack, LeftAttack, LeftStrongAttack,
	Jump, Parry, Dash,
	QuickAccess1, QuickAccess2, QuickAccess3, QuickAccess4,
	Interact,
	Menu, Map,
	EmoteWindow, QuickChat
}
enum PlayerActionSticks {
	Movement,
	Aim
}

enum MenuActionButtons {
	Accept, Reject,
	Up, Down, Left, Right,
	Search,
	ContextMenu,
	Menu, Map
}
enum MenuActionSticks {
	
}

enum MainMenuActionButtons {
	Up, Down, Left, Right,
	Accept, Reject
}
enum MainMenuActionSticks {
	
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
