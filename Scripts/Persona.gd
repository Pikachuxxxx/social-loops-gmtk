extends Node

const PT = preload("res://Scripts/PostType.gd")

# Use POST_TYPE as an enum or bitmask
#export(int, "ASMR", "POLITICAL", "COOKING", "CATS_DOGS_PICS", "TECHNOLOGY", "METAL_MUSIC", "FASHION", "SHOWER_THOUGHTS", "BUSINESS", "MEME", "RANT", "CELEB_GOSSIP", "ASTROLOGY") var post_type = 0

# Exported variables go here, at the top of the class!
const post_type: PT.POST_TYPE = PT.POST_TYPE.MEME
# var porsona type ???
const user_name: String = ""
const occupation: String = ""
const age: int = 0
const drama: float = 0.0
const tolerance: float = 0.0
const influence: float = 0.0
var vibe: float = 100.0
var mood: float = 0.0

@export var number: int = 5

func _ready():
	pass
