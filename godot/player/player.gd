extends RigidBody3D
class_name Player

@onready var tween = create_tween()
@onready var stats = $"../CanvasLayer"

var start_position = Vector3(-16, 13, 0)
var test_position = Vector3(6, 54, 0)

const GRAVITY = 60.0
var is_alive = true

func _ready() -> void:
	global_position = start_position

func _physics_process(delta: float) -> void:
	var input := Vector3.ZERO
		
	input.x = Input.get_axis("move_left", "move_right")
	#input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(input * 1500.0 * delta)
	apply_central_force(Vector3(0, -GRAVITY * mass, 0) * delta)
	# Check if player falls below Y = -10
	global_position.z = start_position.z
	
	if global_position.y < -10.0:
		explode_and_respawn()
	
	if global_position.y > 50:
		explode_and_respawn()
	
func respawn() -> void:
	global_position = start_position
	global_rotation = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

func explode_and_respawn():
	# Disable physics while "exploding"
	set_physics_process(false)

	stats.increment_attempts()
	
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Create explosion animation
	tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ONE * 2.5, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.tween_callback(Callable(self, "_on_explosion_done"))

func _on_explosion_done():
	# Reset state and respawn
	scale = Vector3.ONE
	global_position = start_position
	global_rotation = Vector3.ZERO
	set_physics_process(true)
	is_alive = true
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("projectile") and is_alive == true:
		is_alive = false
		explode_and_respawn()
