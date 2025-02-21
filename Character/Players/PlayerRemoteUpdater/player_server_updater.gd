class_name PlayerServerUpdater extends "res://Character/Players/PlayerRemoteUpdater/player_remote_updater.gd"



func update_position(pos: Vector3) -> void:
	rpc_id(character.player_id,"rpc_position_update", pos)
@rpc
func rpc_position_update(pos: Vector3) -> void:
	character.set_position(pos)
	pass

func send_damage(damage: int) -> void:
	rpc_id(character.player_id, "rpc_send_damage", damage)

@rpc("reliable")
func rpc_send_damage(damage: int):
	character.recv_damage(damage)

func send_healing(healing: int) -> void:
	rpc_id(character.player_id, "rpc_send_healing", healing)

@rpc("reliable")
func rpc_send_healing(healing: int):
	character.recv_healing(healing)
