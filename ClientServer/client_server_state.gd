extends Node


enum IsServer { Uninit, Server, Client }

var server_state: IsServer = IsServer.Uninit

func become_server() -> void:
	server_state = IsServer.Server

func become_client() -> void:
	server_state = IsServer.Client
	

func is_server() -> bool:
	return server_state == IsServer.Server

func is_client() -> bool:
	return server_state == IsServer.Client
