extends Node
class_name MoveScene
@export var path_input: String = ""
@export var transition_time: float = 5.0

func _input(event):
	# Check for a mouse button press.
	if event is InputEventMouseButton and event.pressed:
		if event.button_index==MOUSE_BUTTON_LEFT:
			var scene_path = path_input
			if scene_path != "":
				get_tree().change_scene_to_file(scene_path)
			else:
				print("No scene path provided!")

func _ready():
	# Wait 5 seconds
	#await get_tree().create_timer(transition_time).timeout
	set_process_input(true)
	
	#var scene_path = path_input
	#if scene_path != "":
		#get_tree().change_scene_to_file(scene_path)
	#else:
		#print("No scene path provided!")
