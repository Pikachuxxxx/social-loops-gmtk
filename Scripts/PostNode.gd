extends Node2D
class_name PostNode

const PT = preload("res://Scripts/PostTypes.gd")

func _init():
	pass
	
func set_post(post: Post) -> void:
	var persona: Persona = Globals.g_nodes[post.who_posted].persona
	if(persona and post):
		$UserName.text = persona.user_name
		## TODO: choose a post from post bank based on the type and intent etc.
		$PostMessage.text = PT.get_string_from_value(post.post_type)
