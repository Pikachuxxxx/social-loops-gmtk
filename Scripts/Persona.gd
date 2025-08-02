extends Resource
class_name  Persona

const PT = preload("res://Scripts/PostTypes.gd")
const PERT = preload("res://Scripts/PersonaTypes.gd")

@export var user_name: String = ""
@export var occupation: String = ""
@export var display_pic: Texture2D 
@export var age: int = 0
@export var variant_idx: int = 0
@export var persona_type: PERT.PERSONA_TYPE
@export_flags("ASMR", "POLITICAL", "COOKING", "CATS_DOGS_PICS", "TECHNOLOGY", "METAL_MUSIC", "FASHION", "SHOWER_THOUGHTS", "BUSINESS", "MEME", "RANT", "CELEB_GOSSIP", "ASTROLOGY") 
var likes: int
@export_flags("ASMR", "POLITICAL", "COOKING", "CATS_DOGS_PICS", "TECHNOLOGY", "METAL_MUSIC", "FASHION", "SHOWER_THOUGHTS", "BUSINESS", "MEME", "RANT", "CELEB_GOSSIP", "ASTROLOGY") 
var dislikes: int
# randomly initialized at start for different varaints of the persona type
@export var drama: float = 0.0
@export var tolerance: float = 0.0
@export var influence: float = 0.0
# influenced by simulation
var vibe: float = 100.0
var mood: float = 0.0
var id: int = -1 # node id
