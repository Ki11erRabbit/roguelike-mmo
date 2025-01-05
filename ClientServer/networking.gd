extends Node


var peer: MultiplayerPeer = ENetMultiplayerPeer.new()
const PORT: int = 9009
var players: Dictionary = {}

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






func server_peer_connected(id):
	players[id] = id
	print(id)

func server_peer_disconnected(id):
	players.erase(id)

func client_peer_connected():
	pass

func client_peer_disconnected():
	pass
