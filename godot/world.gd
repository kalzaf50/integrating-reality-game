extends Node3D

func _ready() -> void:
	# Base directory = folder containing the EXE
	var base_dir = OS.get_executable_path().get_base_dir()
	print("Base directory: ", base_dir)

	# Paths relative to base_dir
	var python_path = base_dir + "/python/Scripts/python.exe"
	var script_path = base_dir + "/mediapipe_hand.py"

	print("Launching Python at: ", python_path)
	print("Script at: ", script_path)

	var args = [script_path]

	var pid = OS.create_process(python_path, args, false)

	if pid == -1:
		print("\n--- PROCESS FAILED TO START ---")
		print("Python path: ", python_path)
		print("Script path: ", script_path)
		print("--------------------------------\n")
	else:
		print("MediaPipe launched. PID:", pid)
