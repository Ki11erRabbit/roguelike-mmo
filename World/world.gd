extends Node


var peer: MultiplayerPeer = ENetMultiplayerPeer.new()
const PORT: int = 9009
var players: Dictionary = {}
var peer_id

func start_server():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(server_peer_connected)
	multiplayer.peer_disconnected.connect(server_peer_disconnected)
	print("Server started")

func start_client(address = "127.0.0.1"):
	peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(client_peer_connected)
	multiplayer.server_disconnected.connect(client_peer_disconnected)


@rpc("call_remote")
func set_peer_id(id):
	peer_id = id
	var character = load("res://Character/Players/ControllableCharacter.tscn").instantiate()
	character.set_multiplayer_authority(id)
	$World.add_child(character)
	character.name = "{0}".format([id])
	


func server_peer_connected(id):
	print(id)
	rpc("set_peer_id", id)
	var character = load("res://Character/Players/ControllableCharacter.tscn").instantiate()
	character.set_multiplayer_authority(id)
	$World.add_child(character)
	character.name = "{0}".format([id])
	players[id] = character

func server_peer_disconnected(id):
	$World.remove_child(players[id])
	players.erase(id)

func client_peer_connected():
	pass

func client_peer_disconnected():
	pass

func _ready() -> void:
	if ClientServerState.is_server():
		start_server()
	elif ClientServerState.is_client():
		start_client()
