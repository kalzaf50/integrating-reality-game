extends Node3D

const PORT: int = 4242

var server: UDPServer

var left_hand: Hand
var right_hand: Hand

var hands_data: Dictionary

@onready var stats = $"../CanvasLayer"

func _ready() -> void:
	server = UDPServer.new()
	server.listen(PORT)
	
	left_hand = _create_new_hand()
	right_hand = _create_new_hand()

func _create_new_hand() -> Hand:
	var hand_instance := Hand.new()
	add_child(hand_instance)
	return hand_instance

func _parse_hands_from_packet(data: PackedByteArray) -> Dictionary:
	var json_string = data.get_string_from_utf8()
	var json = JSON.new()
	
	var error = json.parse(json_string)
	assert(error == OK)
	
	var data_received = json.data
	assert(typeof(data_received) == TYPE_DICTIONARY)
	
	return data_received

func _process(_delta: float) -> void:
	server.poll()
	if server.is_connection_available():
		
		if hands_data.has("timestamp"):
			var sent_time = hands_data["timestamp"]
			var now = Time.get_unix_time_from_system()
			var latency = (now - sent_time) * 1000.0
			stats.update_ping(latency)
			
		var peer = server.take_connection()
		var data = peer.get_packet()
		hands_data = _parse_hands_from_packet(data)
		
		if hands_data["left"] != null and hands_data["right"] == null:
			left_hand.set_hand_state(true)
			left_hand.parse_hand_landmarks_from_data(hands_data["left"])
		elif hands_data["right"] != null or (hands_data["right"] == null and hands_data["left"] == null):
			left_hand.set_hand_state(false)
			
		if hands_data["right"] != null and hands_data["left"] == null:
			right_hand.set_hand_state(true)
			right_hand.parse_hand_landmarks_from_data(hands_data["right"])
		elif hands_data["left"] != null or (hands_data["right"] == null and hands_data["left"] == null):
			right_hand.set_hand_state(false)
