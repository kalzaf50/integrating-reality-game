extends RayCast3D

@onready var beam_mesh = $BeamMesh
@onready var end_particles = $EndParticles

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cast_point
	force_raycast_update()

	if is_colliding():
		var collider = get_collider()
		if collider and collider.name == "Player":
			if collider.has_method("explode_and_respawn") and collider.is_alive:
				collider.explode_and_respawn()

		cast_point = to_local(get_collision_point())
		
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y/2
		
		end_particles.position.y = cast_point.y
