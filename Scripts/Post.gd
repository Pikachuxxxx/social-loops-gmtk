extends Node

const PT = preload("res://Scripts/PostTypes.gd")

@export var post_type: PT.POST_TYPE
@export var chaos: float
@export var valence: float
@export var base_engagement: float
var likes_count: int
var who_liked: Array
var who_posted: int
var is_alive: bool
