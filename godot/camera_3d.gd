extends Camera3D

@onready var player: RigidBody3D = $"../Player"
@onready var hand_tracker = $"../HandTracking"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player and not (hand_tracker.left_hand.is_active() or hand_tracker.right_hand.is_active()):
		var target_position = global_position
		target_position.x = player.global_position.x
		target_position.y = player.global_position.y + 7
		
		# Smoothly interpolate to the target position
		global_position = global_position.lerp(target_position, 5 * delta)
