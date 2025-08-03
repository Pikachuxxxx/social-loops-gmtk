extends Node
class_name GroupNode

static var idCount = 0

var id = -1

var isInProgress = false
var nodeIds: Array[int] = []
var onGroupUpdate: Callable = func ():
	pass
var lastPostTime: float = 15.0
signal post_created(post)
var groupProps: GroupProps

# get random color using a random number generator
static func generate_random_color() -> Color:
	var randomColor = Color(randf() , randf(), randf())
	return Color(randomColor.r, randomColor.g, randomColor.b, 1.0)  # Ensure alpha is 1.0

static func generate_random_bright_color() -> Color:
	var hue = randf() # 0.0 to 1.0
	var saturation = 0.8 + randf() * 0.2 # 0.8 to 1.0 (high saturation)
	var value = 0.8 + randf() * 0.2 # 0.8 to 1.0 (high value/brightness)
	return Color.from_hsv(hue, saturation, value, 1.0)

func _init(_isInProgress: bool = false, _onGroupUpdate: Callable = func (): pass) -> void:
	isInProgress = _isInProgress
	onGroupUpdate = _onGroupUpdate
	id = GroupNode.idCount
	GroupNode.idCount += 1
	groupProps = GroupProps.new()
	groupProps.color = generate_random_bright_color()

func get_group_color() -> Color:
	return groupProps.color

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
	emit_signal("post_created", post, groupProps)

func get_engagement() -> float:
	return groupProps.engagement

func get_engagement_percentage() -> int:
	var perct : int=  int(groupProps.engagement * 100) if groupProps.total_posts > 0 else 0
	return perct

func get_total_likes() -> int:
	return groupProps.total_likes

func get_harmony() -> float:
	return groupProps.harmony

func get_drama() -> float:
	return groupProps.drama

func get_liked_posts() -> int:
	return groupProps.liked_posts

func get_disliked_posts() -> int:
	return groupProps.disliked_posts
