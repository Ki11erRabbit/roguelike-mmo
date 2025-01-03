extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$World/Character2.attach_health_bar($World/Character2/EnemyBar, $World/Character/Camera3D)
	$World/Character.attach_health_bar($Hud/HealthBars/PlayerBar, $World/Character/Camera3D)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
