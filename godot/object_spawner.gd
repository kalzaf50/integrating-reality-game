extends Node3D

var projectile_scene  = preload("res://projectile.tscn")
@export var destroy_time: float = 3.0
	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.set_destroy_time(destroy_time)

func _on_spawn_rate_timeout() -> void:
	spawn_projectile()
