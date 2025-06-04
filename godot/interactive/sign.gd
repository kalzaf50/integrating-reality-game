extends Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body.name)


func _on_area_3d_body_exited(body: Node3D) -> void:
	print(body.name)
