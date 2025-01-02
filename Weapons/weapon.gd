class_name Weapon extends Node3D

@onready
var model: Node3D = $model


var hitbox: Area3D

@export
var stats: WeaponStats


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
