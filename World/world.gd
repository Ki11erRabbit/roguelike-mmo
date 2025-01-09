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
	$Timer.start()

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
	var character: Character = load("res://Character/Players/PlayerControledCharacter.tscn").instantiate()
	var client_updater = load("res://Character/Players/PlayerRemoteUpdater/player_client_updater.tscn").instantiate()
	client_updater.name = "ClientUpdater"
	character.client_updater = client_updater
	character.set_multiplayer_authority(id)
	var server_updater = load("res://Character/Players/PlayerRemoteUpdater/player_server_updater.tscn").instantiate()
	server_updater.name = "ServerUpdater"
	character.server_updater = server_updater
	character.player_id = id
	character.name = "{0}".format([id])
	players[id] = character
	ClientServerState.peer_id = id
	var hud = load("res://Menus/HUD/hud.tscn").instantiate()
	add_child(hud)
	character.health_bar = hud.player_bar
	$World.add_child(character)
	character.position.x = 1
	character.position.y = 1
	
@rpc("call_remote")
func add_players(ids: Array):
	for id in ids:
		if peer_id == id or id in players:
			return
		var character = load("res://Character/Players/server_controled_character.tscn").instantiate()
		character.player_id = id
		var client_updater = load("res://Character/Players/PlayerRemoteUpdater/player_client_updater.tscn").instantiate()
		client_updater.name = "ClientUpdater"
		character.client_updater = client_updater
		character.set_multiplayer_authority(id)
		var server_updater = load("res://Character/Players/PlayerRemoteUpdater/player_server_updater.tscn").instantiate()
		server_updater.name = "ServerUpdater"
		character.server_updater = server_updater
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
	var client_updater = load("res://Character/Players/PlayerRemoteUpdater/player_client_updater.tscn").instantiate()
	client_updater.name = "ClientUpdater"
	character.client_updater = client_updater
	character.set_multiplayer_authority(id)
	var server_updater = load("res://Character/Players/PlayerRemoteUpdater/player_server_updater.tscn").instantiate()
	server_updater.name = "ServerUpdater"
	character.server_updater = server_updater
	character.name = "{0}".format([id])
	players[id] = character
	rpc("add_players", players.keys())
	$World.add_child(character)
	character.position.x = 1
	character.position.y = 1

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


func _on_timer_timeout() -> void:
	rpc("add_enemy", false)
	add_enemy(true)

@rpc
func add_enemy(server: bool):
	var character = load("res://Character/Enemies/Dummy/dummy.tscn").instantiate()
	character.on_server = server
	var client_updater = load("res://Character/Players/PlayerRemoteUpdater/player_client_updater.tscn").instantiate()
	client_updater.name = "ClientUpdater"
	character.client_updater = client_updater
	var server_updater = load("res://Character/Players/PlayerRemoteUpdater/player_server_updater.tscn").instantiate()
	server_updater.name = "ServerUpdater"
	character.server_updater = server_updater
	$World.add_child(character)
