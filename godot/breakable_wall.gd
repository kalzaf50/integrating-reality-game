extends RigidBody3D

var start_position = self.get_position()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_position.y < -10.0:
		respawn()

func respawn():
	global_transform.origin = start_position
	rotation_degrees = Vector3(0, 0, 0) 
