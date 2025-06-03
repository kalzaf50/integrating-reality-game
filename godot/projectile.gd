extends Node3D

@onready var destroy_timer = $DestroyTimer

func set_destroy_time(duration: float) -> void:
	destroy_timer.wait_time = duration
	destroy_timer.start()
	
func _on_destroy_timer_timeout() -> void:
	queue_free()
