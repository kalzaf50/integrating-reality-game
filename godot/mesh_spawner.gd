extends Node3D

func _ready():
	#var Projectile = load("res://projectile.tscn")
	#var ProjCopies = Projectile.instance()
	#add_child(ProjCopies)
	pass

func spawn_ProjCopies():
	var Projectile = load("res://projectile.tscn")
	var ProjCopies = Projectile.instantiate()
	add_child(ProjCopies)

func _on_timer_timeout() -> void:
	spawn_ProjCopies()
