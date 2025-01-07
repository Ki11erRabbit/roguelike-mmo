class_name RemoteUpdater extends Node

var character: Character
# TODO: add rpc methods that then call methods on their character parent that sets certain values

@rpc
func rpc_position_update(pos: Vector3) -> void:
	#character.set_position(pos)
	pass

@rpc
func rpc_equip_weapons():
	if not character.weapons_equiped:
		character.should_equip = true

@rpc
func rpc_unequip_weapons():
	if character.weapons_equiped:
		character.unequip_weapons()
		character.should_equip = false
