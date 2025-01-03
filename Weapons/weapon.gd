class_name Weapon extends Area3D

signal done_attacking(weapon_id: int)


@export
var model: Node3D

@export
var stats: WeaponStats

var enable_collision: bool = false:
	set(value):
		if not value:
			attack_finished()
		enable_collision = value
			

@export
var collision_shape: BoxShape3D:
	set(value):
		var range: float = stats.range
		var length: float = stats.length
		value.size.y = range
		$CollisionShape3D.position.y = range / 2 + length / 2
		
		collision_shape = value
		$CollisionShape3D.shape = value



@export
var wielder: Character

func initialize(wielder: Character):
	self.wielder = wielder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	model.position.y += stats.hand_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack_finished():
	emit_signal("done_attacking", get_id())

func get_id() -> int:
	return get_instance_id()

func _on_area_entered(area: Area3D) -> void:
	if not enable_collision:
		return
	if area.is_in_group("attacking_group"):
		var character: Character = area.owner.character.collide_weapon(self)
		if character == null:
			return
		
		var combat_calculator: CombatCalculator = CombatCalculator.new()
		
		var damage: int = combat_calculator.calculate_damage_done(self.stats, wielder.stats, character.stats)
		print(damage)
		
		character.add_damage(damage)
