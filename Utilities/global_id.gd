extends Node

var next_id: int = 0:
	get():
		var id = next_id
		next_id += 1
		return id


func get_id() -> int:
	return next_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
