extends Node
class_name PostManager

"""
Post {
	startAt: time, // using the Time Object
	endAt: time, // using the Time Object, calculated with amt of reaction times, expands if new rxns are added (due to group movement)
	rxns: Rxn[]
}

Rxn {
	type: view, like, dislike, comment,
	[comment]: string,
	[comment_type]: CommentType // Is it required? can be used to influence others and later posts
}

"""



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
