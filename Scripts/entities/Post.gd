extends Node
class_name XPost

@export_flags("ASMR", "POLITICAL", "COOKING", "CATS_DOGS_PICS", "TECHNOLOGY", "METAL_MUSIC", "FASHION", "SHOWER_THOUGHTS", "BUSINESS", "MEME", "RANT", "CELEB_GOSSIP", "ASTROLOGY") 
var type: int
var startAt: int = 0
var endAt: int = 0
var rxns: Array[Reaction] = []
var nodeId: int = -1
