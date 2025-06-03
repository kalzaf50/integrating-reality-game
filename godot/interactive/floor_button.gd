extends Node3D

@onready var anim = $AnimationPlayer
var continuous_cd = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.name in ["Player", "@RigidBody3D@11"]:
		anim.play("press_down")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name in ["Player", "@RigidBody3D@11"]:
		anim.play("press_up")
