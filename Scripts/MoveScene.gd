extends Node
class_name MoveScene
@export var path_input: String = ""
@export var transition_time: float = 5.0

func _ready():
	# Wait 5 seconds
	await get_tree().create_timer(transition_time).timeout
	var scene_path = path_input
	if scene_path != "":
		get_tree().change_scene_to_file(scene_path)
	else:
		print("No scene path provided!")
