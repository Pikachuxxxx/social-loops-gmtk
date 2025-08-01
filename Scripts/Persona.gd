extends Node

const PT = preload("res://Scripts/PostTypes.gd")
const PERT = preload("res://Scripts/PersonaTypes.gd")

@export var persona_type: PERT.PERSONA_TYPE
@export var interests: PT.POST_TYPE
@export var dislikes: PT.POST_TYPE
@export var user_name: String = ""
@export var occupation: String = ""
@export var age: int = 0
@export var variant_idx: int = 0
# randomly initialized at start for different varaints of the persona type
const drama: float = 0.0
const tolerance: float = 0.0
const influence: float = 0.0
# influenced by simulation
var vibe: float = 100.0
var mood: float = 0.0
