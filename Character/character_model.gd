class_name CharacterModel extends Node3D

signal animation_finished(anim_name: StringName)

var model: Node3D

func initialize(model: Node3D):
	self.model = model
	self.model.animation_finished.connect(emit_animation_finished)
	add_child(model)

func equip_weapons(right_hand: Node3D, left_hand: Node3D):
	if right_hand != null:
		model.equip_right_hand(right_hand)
	if left_hand != null:
		model.equip_left_hand(left_hand)

func unequip_weapons() -> Array[Node3D]:
	var weapons: Array[Node3D] = [
		model.unequip_right_hand(),
		model.unequip_left_hand()
	]
	return weapons

func play_animation(anim_name: String, weapon: String, hand: String):
	var combined_name: String = weapon + "_" + hand + "_hand_" + anim_name
	match hand:
		"right":
			model.right_arm_state_machine.travel(combined_name)
		"left":
			model.left_arm_state_machine.travel(combined_name)
		"both":
			model.both_arm_state_machine.travel(combined_name)

func play_body_animation(anim_name: String):
	model.body_state_machine.travel(anim_name)

func emit_animation_finished(anim_name: StringName):
	emit_signal("animation_finished", anim_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
