extends Resource
class_name Post

@export_flags("ASMR", "POLITICAL", "COOKING", "CATS_DOGS_PICS", "TECHNOLOGY", "METAL_MUSIC", "FASHION", "SHOWER_THOUGHTS", "BUSINESS", "MEME", "RANT", "CELEB_GOSSIP", "ASTROLOGY") 
var type: int
@export var chaos: float
@export var valence: float
@export var base_engagement: float
var rxns: Array[Reaction] = []
var likes_count: int
var dislikes_count: int
var who_liked: Array[int]
var who_posted: int
var is_active: bool