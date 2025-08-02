extends Resource
class_name Post

const PT = preload("res://Scripts/PostTypes.gd")

@export var post_type: PT.POST_TYPE
@export var chaos: float
@export var valence: float
@export var base_engagement: float
var likes_count: int
var dislikes_count: int
var who_liked: Array[int]
var who_posted: int
var is_active: bool

func init(who: int, post_type: PT.POST_TYPE):
	likes_count = 0
	who_liked = []
	is_active = true
	self.who_posted = who
	self.post_type = post_type
	# TODO: In future iteration the node's factors will be used to determine these values in addition to being randomized and also based on the post type
	# For now, they are just randomized
	chaos = randf() * 2.0 - 1.0
	valence = randf() * 2.0 - 1.0
	base_engagement = randf() * 2.0 - 1.0


func like(persona: Persona):
	if persona and not who_liked.has(persona.id):
		print("Persona %s liked post %d" % [persona.user_name, post_type])
		who_liked.append(persona.id)
		likes_count += 1

func dislike(persona: Persona):
	if persona and who_liked.has(persona.id):
		print("Persona %s disliked post %d" % [persona.user_name, post_type])
		who_liked.erase(persona.id)
		dislikes_count += 1
		likes_count -= 1
