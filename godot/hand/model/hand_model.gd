extends Node3D

@onready var skeleton: Skeleton3D = $Sketchfab_model/Root/Armature/Skeleton3D
@onready var hand_tracker = $"../HandTracking"

var bone_names = [
	"Armature_rootJoint",
	"Bone_Armature",
	"Bone.001_Armature",
	"Bone.002_Armature",
	"Bone.003_Armature",
	"Bone.004_Armature",
	"Bone.005_Armature",
	"Bone.006_Armature",
	"Bone.007_Armature",
	"Bone.008_Armature",
	"Bone.009_Armature",
	"Bone.010_Armature",
	"Bone.011_Armature",
	"Bone.012_Armature",
	"Bone.013_Armature",
	"Bone.014_Armature",
	"Bone.015_Armature",
	"Bone.016_Armature",
	"Bone.017_Armature",
	"Bone.018_Armature",
	"Bone.019_Armature"
]

var point_finger_bones = [
	"Bone.004_Armature",
	"Bone.005_Armature",
	"Bone.006_Armature",
	"Bone.007_Armature"
]

var landmark_positions = []
var point_finger_landmark_indices = [5, 6, 7, 8]

func update_point_finger_rotations(landmarks: Array) -> void:
	# Each finger bone corresponds to a pair of landmarks (start, end)
	var bone_landmark_pairs = [
		[5, 6],
		[6, 7],
		[7, 8],
		# If you want a 4th bone, add the next pair here (depends on rig)
	]

	for i in range(bone_landmark_pairs.size()):
		var bone_name = point_finger_bones[i]
		var bone_idx = skeleton.find_bone(bone_name)
		if bone_idx == -1:
			continue

		var start_idx = bone_landmark_pairs[i][0]
		var end_idx = bone_landmark_pairs[i][1]

		if start_idx >= landmarks.size() or end_idx >= landmarks.size():
			continue

		var start_pos = Vector3(landmarks[start_idx][0], landmarks[start_idx][1], landmarks[start_idx][2])
		var end_pos = Vector3(landmarks[end_idx][0], landmarks[end_idx][1], landmarks[end_idx][2])

		var direction = (end_pos - start_pos).normalized()
		var rest_dir = Vector3(0, 1, 0)  # Adjust if your bone rest direction differs

		# Calculate rotation axis and angle between rest_dir and direction
		var axis = rest_dir.cross(direction)
		var angle = acos(clamp(rest_dir.dot(direction), -1, 1))

		var basis: Basis
		if axis.length() > 0.001:
			axis = axis.normalized()
			basis = Basis(axis, angle)
		else:
			basis = Basis()

		# Apply local bone rotation override with no translation (Vector3.ZERO)
		skeleton.set_bone_pose(bone_idx, Transform3D(basis, Vector3.ZERO))

func _ready() -> void:
	var bone_count = skeleton.get_bone_count()
	print("Total bones:", bone_count)
	for i in range(bone_count):
		print("Bone ", i, ":", skeleton.get_bone_name(i))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hand_tracker.hands_data.has("right") and hand_tracker.hands_data["right"] != null:
		#update_bone_transforms(hand_tracker.hands_data["right"])
		update_point_finger_rotations(hand_tracker.hands_data["right"])
