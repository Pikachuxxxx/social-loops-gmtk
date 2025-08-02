## Main Social Sim Alg
## and someglobal variables
extends Node
class_name Zuck

const PT = preload("res://Scripts/PostTypes.gd")
const PERT = preload("res://Scripts/PersonaTypes.gd")

@export var post_cooldown_time_sec: int 
@export var round_cooldown_time_sec: int 

func get_random_liked_index(bitfield: int, enum_size: int) -> int:
	var indices = []
	for i in range(enum_size):
		if bitfield & (1 << i):
			indices.append(i)
	if indices.size() > 0:
		return indices[randi() % indices.size()]
	return -1

func process(delta: float) -> void:
	for group in Globals.g_groups:
		if group.nodeIds.size() < 3:
			continue
		
		# Check if the group is ready to post based on cooldown time
		if group.lastPostTime + post_cooldown_time_sec > (Time.get_ticks_msec() / 1000.0):
			continue
		
		group.lastPostTime = (Time.get_ticks_msec() / 1000.0)
		print("====================")
		print("Group %d is posting" % group.id)
		# Randomly pick a persona to post
		var postingPersonaID: int = randi() % group.nodeIds.size()
		var postingPersonaNode: PersonaNode = Globals.g_nodes[group.nodeIds[postingPersonaID]]
		if not postingPersonaNode or not postingPersonaNode.persona:
			continue
		var likes: int = postingPersonaNode.persona.likes
		var likedPostIndex: int = get_random_liked_index(likes, PT.POST_TYPE.MAX_POST_TYPES)
		var post: Post = Post.new();
		print("Posting from %s with post type %d" % [postingPersonaNode.persona.user_name, likedPostIndex])
		print("--------------------")
		# TODO: In future we can have pre-defined curated posts based on the persona's likes etc.
		# For now, we just create a new post with the liked post type
		post.init(postingPersonaNode.id, likedPostIndex)
		group.make_post(post)
	pass
