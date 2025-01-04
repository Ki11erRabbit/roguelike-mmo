extends Area3D

@onready
var detection_sphere: CollisionShape3D = $DetectionSphere

@export
var radius: float:
	set(value):
		radius = value
		detection_sphere.shape.radius = value

var targets

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
