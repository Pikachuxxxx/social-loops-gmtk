extends Node
class_name Group

var isInProgress = false
var nodeIds: Array[int] = []

func _init(_isInProgress: bool = false) -> void:
	isInProgress = _isInProgress

func add_node_id (nodeId: int) -> void:
	if not nodeIds.has(nodeId): # Use dictionary instead?
		nodeIds.append(nodeId)
