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
	InputManager.disable_input()

func start_client(address = "127.0.0.1"):
	peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(client_peer_connected)
	multiplayer.server_disconnected.connect(client_peer_disconnected)
	print(get_multiplayer_authority())


@rpc("call_remote")
func set_peer_id(id):
	print(get_multiplayer_authority())
	peer_id = id
	var character = load("res://Character/Players/PlayerControledCharacter.tscn").instantiate()
	character.set_multiplayer_authority(id)
	var remote_updater = RemoteUpdater.new()
	remote_updater.name = "RemoteUpdater"
	character.remote_updater = remote_updater
	character.player_id = id
	character.name = "{0}".format([id])
	players[id] = character
	ClientServerState.peer_id = id
	$World.add_child(character)
	
@rpc("call_remote")
func add_players(ids: Array):
	for id in ids:
		if peer_id == id or id in players:
			return
		var character = load("res://Character/Players/ControllableCharacter.tscn").instantiate()
		character.player_id = id
		var remote_updater = RemoteUpdater.new()
		remote_updater.name = "RemoteUpdater"
		character.remote_updater = remote_updater
		#character.set_multiplayer_authority(id)
		character.name = "{0}".format([id])
		players[id] = character
		$World.add_child(character)

@rpc("call_remote")
func remove_player(id):
	$World.remove_child(players[id])
	players.erase(id)

func server_peer_connected(id):
	print(id)
	rpc("set_peer_id", id)
	var character = load("res://Character/Players/ControllableCharacter.tscn").instantiate()
	character.player_id = id
	character.set_multiplayer_authority(id)
	var remote_updater = RemoteUpdater.new()
	remote_updater.name = "RemoteUpdater"
	character.remote_updater = remote_updater
	character.name = "{0}".format([id])
	players[id] = character
	rpc("add_players", players.keys())
	$World.add_child(character)

func server_peer_disconnected(id):
	print("removing")
	print(id)
	$World.remove_child(players[id])
	players.erase(id)
	rpc("remove_player", id)

func client_peer_connected():
	pass

func client_peer_disconnected():
	pass

func _ready() -> void:
	if ClientServerState.is_server():
		start_server()
		var camera = Camera3D.new()
		$World.add_child(camera)
		camera.rotation_degrees.x = -90
		camera.position.y = 9.4
	elif ClientServerState.is_client():
		start_client()
