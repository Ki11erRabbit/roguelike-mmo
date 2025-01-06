extends Area3D

@onready
var detection_sphere: CollisionShape3D = $DetectionSphere


@export
var radius: float:
	set(value):
		radius = value
		if detection_sphere == null:
			return
		detection_sphere.shape.radius = value

var targets: PriorityQueue = PriorityQueue.new()
var in_range: Dictionary = {}

var agro_priority: int = 0:
	get():
		var out: int = agro_priority
		agro_priority += 1
		return out

@export
var control_box: AIControlBox

## character is the character the ai is connected to
func process_ai(delta: float, character: Character) -> void:
	pass

func get_next_target() -> AITarget:
	var min: AITarget = targets.get_min()
	if min == null:
		return null
	while min.get_id() not in in_range:
		targets.delete_min()
		min = targets.get_min()
		if min == null:
			return null
	return min

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targets.initialize([], func(x, y): return x.compare(y))
	detection_sphere.shape.radius = radius



func took_damage(character: Character):
	if character.get_id() in in_range:
		var old_target: AITarget = in_range[character.get_id()]
		var new_target: AITarget = AITarget.new()
		new_target.initialize(character,old_target.priority - 10)
		targets.update_key(old_target, new_target)
	else:
		var target: AITarget = AITarget.new()
		target.initialize(character, agro_priority - 10)
		in_range[character.get_id()] = target

func _on_area_entered(area: Area3D) -> void:
	if not area.is_in_group("agro_detection"):
		return
	print("collision")
	var character: Character = area.owner
	var target: AITarget = AITarget.new()
	target.initialize(character, agro_priority)
	in_range[character.get_id()] = target
	targets.insert(target)


func _on_area_exited(area: Area3D) -> void:
	if not area.is_in_group("agro_detection"):
		return
	var character: Character = area.owner
	in_range.erase(character.get_id())
	


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("agro_detection"):
		return
	if owner == body:
		return
	print("collision")
	var character: Character = body
	var target: AITarget = AITarget.new()
	target.initialize(character, agro_priority)
	in_range[character.get_id()] = target
	targets.insert(target)


func _on_body_exited(body: Node3D) -> void:
	if not body.is_in_group("agro_detection"):
		return
	if owner == body:
		return
	var character: Character = body
	in_range.erase(character.get_id())
