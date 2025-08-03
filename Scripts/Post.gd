extends Resource
class_name Post

const PT = preload("res://Scripts/PostTypes.gd")
const RXN = preload("res://Scripts/Reaction.gd")

#@export_flags("ASMR", "POLITICAL", "COOKING", "CATS_DOGS_PICS", "TECHNOLOGY", "METAL_MUSIC", "FASHION", "SHOWER_THOUGHTS", "BUSINESS", "MEME", "RANT", "CELEB_GOSSIP", "ASTROLOGY") 
# Currently the post type is only contains one type, in future we can expand this to multiple types
@export var post_type: PT.POST_TYPE = PT.POST_TYPE.MEME
@export var chaos: float
@export var valence: float
@export var base_engagement: float
var rxns: Array[Reaction] = []
var likes_count: int
var dislikes_count: int
var who_liked: Array[int]
var who_posted: int
var is_active: bool

func init(who: int, post_type: PT.POST_TYPE):
	likes_count = 0
	dislikes_count = 0
	who_liked = []
	who_liked.clear()
	is_active = true
	self.who_posted = who
	self.post_type = post_type
	# TODO: In future iteration the node's factors will be used to determine these values in addition to being randomized and also based on the post type
	# For now, they are just randomized
	chaos = randf() * 2.0 - 1.0
	valence = randf() * 2.0 - 1.0
	base_engagement = randf() * 2.0 - 1.0
	rxns = []

func like(persona: Persona):
	if persona:
		print("Persona %s liked post %d" % [persona.user_name, post_type])
		who_liked.append(persona.id)
		likes_count += 1
		var rxn: Reaction = RXN.new()
		rxn.type = Reaction.RxnType.LIKE
		rxn.nodeId = persona.id
		add_reaction(rxn)

func dislike(persona: Persona):
	if persona:
		print("Persona %s disliked post %d" % [persona.user_name, post_type])
		who_liked.erase(persona.id)
		dislikes_count += 1
		#likes_count -= 1
		var rxn: Reaction = RXN.new()
		rxn.type = Reaction.RxnType.DISLIKE
		rxn.nodeId = persona.id
		add_reaction(rxn)

func comment(persona: Persona, comment: String):
	if persona:
		print("Persona %s commented on post %d" % [persona.user_name, post_type])
		var rxn: Reaction = RXN.new()
		rxn.type = Reaction.RxnType.COMMENT
		rxn.nodeId = persona.id
		rxn.comment = comment
		add_reaction(rxn)

func add_reaction(rxn: Reaction):
	if rxn and not rxns.has(rxn):
		print("Adding reaction %s to post %d" % [rxn.type, post_type])
		rxns.append(rxn)	

func get_last_rxn() -> Reaction:
	if rxns.size() > 0:
		return rxns[rxns.size() - 1]
	return null
