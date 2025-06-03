extends MeshInstance3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Body entered:", body.name)
