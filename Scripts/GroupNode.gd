extends Node
class_name GroupNode

static var idCount = 0

var id = -1

var isInProgress = false
var nodeIds: Array[int] = []
var onGroupUpdate: Callable = func ():
	pass
var lastPostTime: float = 0.0
signal post_created(post)
var group: Group

func _init(_isInProgress: bool = false, _onGroupUpdate: Callable = func (): pass) -> void:
	isInProgress = _isInProgress
	onGroupUpdate = _onGroupUpdate
	id = GroupNode.idCount
	GroupNode.idCount += 1

func add_node_id (nodeId: int, nodeCB: Callable) -> void:
	if not nodeIds.has(nodeId): # Use dictionary instead?
		nodeIds.append(nodeId)
		self.connect("post_created", nodeCB)
		onGroupUpdate.call()

func insert_node_id (insertIdx: int, nodeId: int, nodeCB: Callable) -> void:
	if not nodeIds.has(nodeId): # Use dictionary instead?
		nodeIds.insert(insertIdx, nodeId)
		self.connect("post_created", nodeCB)
		onGroupUpdate.call()

func erase_node (nodeId: int, nodeCB: Callable):
	nodeIds.erase(nodeId)
	self.disconnect("post_created", nodeCB)
	onGroupUpdate.call()

func make_post(post):
	emit_signal("post_created", post, group)
