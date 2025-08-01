extends Node
class_name Group

var isInProgress = false
var nodeIds: Array[int] = []
var onGroupUpdate: Callable = func ():
	pass

func _init(_isInProgress: bool = false, _onGroupUpdate: Callable = func (): pass) -> void:
	isInProgress = _isInProgress
	onGroupUpdate = _onGroupUpdate

func add_node_id (nodeId: int) -> void:
	if not nodeIds.has(nodeId): # Use dictionary instead?
		nodeIds.append(nodeId)
		onGroupUpdate.call()

func insert_node_id (insertIdx: int, nodeId: int) -> void:
	if not nodeIds.has(nodeId): # Use dictionary instead?
		nodeIds.insert(insertIdx, nodeId)
		onGroupUpdate.call()

func erase_node (nodeId: int):
	nodeIds.erase(nodeId)
	onGroupUpdate.call()
