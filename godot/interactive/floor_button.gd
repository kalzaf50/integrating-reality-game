extends Node3D

@onready var button_anim = $AnimationPlayer
@onready var gate_anim = $"../Gate1/AnimationPlayer"

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.name in ["Player", "@RigidBody3D@10"]:
		button_anim.play("press_down")
		gate_anim.play("open")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name in ["Player", "@RigidBody3D@10"]:
		button_anim.play("press_up")
		gate_anim.play("closed")
