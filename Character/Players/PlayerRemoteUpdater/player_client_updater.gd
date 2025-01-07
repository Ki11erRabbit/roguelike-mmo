class_name PlayerClientUpdater extends "res://Character/Players/PlayerRemoteUpdater/player_remote_updater.gd"



func equip_weapons():
	rpc("rpc_equip_weapons")

@rpc
func rpc_equip_weapons():
	if not character.weapons_equiped:
		character.should_equip = true

func unequip_weapons():
	rpc("rpc_unequip_weapons")

@rpc
func rpc_unequip_weapons():
	if character.weapons_equiped:
		character.unequip_weapons()
		character.should_equip = false
