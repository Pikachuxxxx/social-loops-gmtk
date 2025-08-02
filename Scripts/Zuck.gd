## Main Social Sim Alg
## and someglobal variables
extends Node
class_name Zuck

const PT = preload("res://Scripts/PostTypes.gd")
const PERT = preload("res://Scripts/PersonaTypes.gd")

@export var post_cooldown_time_sec: int 
@export var round_cooldown_time_sec: int 

func make_post(_post: Post):

	pass

func pick_persona_to_post() -> Persona:
	var persona: Persona =null;
	return persona

func get_random_liked_index(bitfield: int, enum_size: int) -> int:
	var indices = []
	for i in range(enum_size):
		if bitfield & (1 << i):
			indices.append(i)
	if indices.size() > 0:
		return indices[randi() % indices.size()]
	return -1

func process(group: GroupNode, nodes: Array[PersonaNode]) -> void:
	for nodeId in group.nodeIds:
		var node: PersonaNode = nodes[nodeId]
		if node and node.persona:
			var likes: int = node.persona.likes
			var likedPostIndex: int = get_random_liked_index(likes, PT.POST_TYPE.MAX_POST_TYPES)
			if likedPostIndex != -1:
				# TODO: In future we can have different post types based on the persona's likes
				#var post: Post = PT.POST_TYPE_RESOURCES[likedPostIndex].instantiate() as Post
				var post: Post = Post.new(node, likedPostIndex)
				if post:
					make_post(post)
	pass
