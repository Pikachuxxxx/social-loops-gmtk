extends Node
class_name GroupNode

static var idCount = 0

var id = -1

var isInProgress = false
var nodeIds: Array[int] = []
var onGroupUpdate: Callable = func ():
	pass
var lastPostTime: float = 0.0

func _init(_isInProgress: bool = false, _onGroupUpdate: Callable = func (): pass) -> void:
	isInProgress = _isInProgress
	onGroupUpdate = _onGroupUpdate
	id = GroupNode.idCount
	GroupNode.idCount += 1

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
