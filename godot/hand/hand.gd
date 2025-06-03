extends Node3D

class_name Hand

const NUM_LANDMARKS: int = 21
const HAND_SCALE: float = 30.0
const color_active = Color(22,105,156, 255)
const color_inactive = Color(0.5, 0.5, 0.5, 255)

const HAND_LINES_MAPPING = [
	[0, 1], [1, 2], [2, 3], [3, 4], # Thumb
	[0, 5], [5, 6], [6, 7], [7, 8], # Index Finger
	[5, 9], [9, 10], [10, 11], [11, 12], # Middle Finger
	[9, 13], [13, 14], [14, 15], [15, 16], # Ring Finger
	[0, 17], [13, 17], [17, 18], [18, 19], [19, 20], # Pinky
]

var landmark_sphere: PackedScene = preload("res://hand/hand_landmark.tscn")

var hand_landmarks: Array[HandLandmark] = []
var hand_lines: Array[MeshInstance3D] = []

#Activation indicator variables
var active: bool
var active_timer:=  0.0
var deactive_timer:= 0.0
const active_timeout:= 0.3

func _ready() -> void:
	_create_hand_landmark_spheres()
	_create_hand_lines()

func _create_hand_landmark_spheres() -> void:
	for i in range(NUM_LANDMARKS):
		var landmark_instance = landmark_sphere.instantiate() as HandLandmark
		landmark_instance.from_landmark_id(i)
		add_child(landmark_instance)
		hand_landmarks.append(landmark_instance)

func _create_hand_lines() -> void:
	for i in HAND_LINES_MAPPING.size():
		var line_instance := MeshInstance3D.new()
		add_child(line_instance)
		hand_lines.append(line_instance)

func _process(delta: float) -> void:
	_update_hand_lines()
	
	if active:
		active_timer += delta
	else:
		active_timer = 0.0
	# Enable collision when nearing timeout
	set_hand_collision(active_timer < 2.0)
	
func _update_hand_lines() -> void:
	for i in HAND_LINES_MAPPING.size():
		var mapping = HAND_LINES_MAPPING[i]
		var p0 = hand_landmarks[mapping[0]].global_position
		var p1 = hand_landmarks[mapping[1]].global_position
		LineRenderer.edit_line(hand_lines[i], p0, p1)

func _update_hand_landmark(landmark_id: int, landmark_pos: Vector3) -> void:
	var lm = hand_landmarks[landmark_id]
	lm.target = landmark_pos

func parse_hand_landmarks_from_data(hand_data: Array) -> void:
	var camera = get_viewport().get_camera_3d()
	for lm_id in range(NUM_LANDMARKS):
		var lm_data = hand_data[lm_id]
		var pos_cam = Vector3(lm_data[0], lm_data[1], lm_data[2]) - Vector3.ONE * 0.5
		var pos_xyz = Vector3(-pos_cam[0], -pos_cam[1], pos_cam[2]) * HAND_SCALE
		pos_xyz.x += camera.global_position.x
		pos_xyz.y += camera.global_position.y
		pos_xyz.z += 17
		_update_hand_landmark(lm_id, pos_xyz)

func set_hand_collision(collision:bool) -> void:
	for landmark in hand_landmarks:
		landmark.set_active_color(collision) # <- Use this
		var collider := landmark.get_node_or_null("CollisionShape3D")
		if collider:
			collider.disabled = collision
			
func set_hand_state(visibility:bool) -> void:
	
	active = visibility
	for landmark in hand_landmarks:
		landmark.visible = visibility
	
	for line in hand_lines:
		line.visible = visibility

func is_active() -> bool:
	return active
