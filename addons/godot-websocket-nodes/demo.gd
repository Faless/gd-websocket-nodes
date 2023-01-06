extends Control

func _ready():
	start_server()
	await get_tree().create_timer(1.0).timeout
	start_client()
	await get_tree().create_timer(1.0).timeout
	$WebSocketClient.send("Some message from the client")
	await get_tree().create_timer(1.0).timeout
	for id in $WebSocketServer.peers:
		$WebSocketServer.send(id, JSON.stringify({
			"message": "JSON message from the server.",
			"payload": "Some payload"
		}))


func start_server():
	$WebSocketServer.listen(8080)


func start_client():
	$WebSocketClient.connect_to_url("ws://localhost:8080")


func _on_web_socket_server_client_connected(peer_id):
	print("[Server] New peer connected. ID: ", peer_id)


func _on_web_socket_server_client_disconnected(peer_id):
	print("[Server] Peer disconnected. ID: ", peer_id)


func _on_web_socket_server_message_received(peer_id, message):
	print("[Server] Message received from client. ID: %d, Message: %s" % [peer_id, message])


func _on_web_socket_client_connected_to_server():
	print("[Client] Connected to server!")


func _on_web_socket_client_connection_closed():
	print("[Client] Connection closed.")


func _on_web_socket_client_message_received(message):
	print("[Client] Message received from server. Message: %s" % [message])
