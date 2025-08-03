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
const PT = preload("res://Scripts/PostTypes.gd")

const POST_START_OFFSET = 3 * 1000
const POST_MIN_END_OFFSET = 6 * 1000
const RXN_START_OFFSET = 1 * 1000
const RXN_TIME = 0.5 * 1000
const RXN_COMMENT_TIME = 2 * 1000
const RXN_COMMENT_READ_TIME = 2 * 1000 # Maybe calculate it dynamically

static var posts: Array[XPost] = []

static func process(currTime: int) -> void:
	var activePostCount = get_active_posts(currTime)

	#print("Posts Active: " + str(activePostCount))
	if posts.size() == 0 and  currTime - GameManager.START_TIME > GameManager.START_TIME_OFFSET:
		print("Create first post")
		PostManager.generate_new_post(currTime)
		
	if activePostCount == 0 and currTime - GameManager.START_TIME > GameManager.START_TIME_OFFSET + POST_START_OFFSET + POST_MIN_END_OFFSET:
		PostManager.generate_new_post(currTime)

static func generate_new_post (currTime: int):
	print("Generating new post")
	var post = XPost.new()
	post.startAt = currTime + POST_START_OFFSET

	var node = Globals.g_nodes[randi_range(0, Globals.g_nodes.size()-1)]	
	post.type = Zuck.get_random_liked_index(node.persona.likes, PT.POST_TYPE.MAX_POST_TYPES)
	post.nodeId = node.id
	
	post.endAt = post.startAt + POST_MIN_END_OFFSET
	for group in Globals.g_groups:
		if group.nodeIds.has(post.nodeId):
			for gNodeId in group.nodeIds:
				if gNodeId != post.nodeId:
					var rxnNode = Globals.get_persona_node(gNodeId)
					var likesPost = post.type & rxnNode.persona.likes > 0
					var rxn = Reaction.new()
					rxn.startAt = post.startAt + RXN_START_OFFSET + randi_range(0,2) * 1000
					rxn.nodeId = rxnNode.id
					if likesPost:
						rxn.type = Reaction.RxnType.LIKE
					else:
						rxn.type = Reaction.RxnType.DISLIKE	
					post.rxns.append(rxn)
					var commentTime = 0
					if randf_range(0,1) > 0.5:
						var commentRxn = Reaction.new()
						commentRxn.type = Reaction.RxnType.COMMENT
						commentRxn.nodeId = rxnNode.id
						commentRxn.startAt = rxn.startAt + RXN_COMMENT_TIME + randi_range(0,3) * 1000
						commentRxn.comment = "Some comment"
						commentTime = commentRxn.startAt + RXN_COMMENT_READ_TIME
						post.rxns.append(rxn)
					var postEndAt = rxn.startAt + RXN_TIME + commentTime
					if postEndAt > post.endAt:
						post.endAt = postEndAt
	posts.append(post)
	print("Post start: " + str(post.startAt) + ", end: " + str(post.endAt))
	var likes = str(post.rxns.filter(func(rxn): return rxn.type == Reaction.RxnType.LIKE).size())
	var dislikes = str(post.rxns.filter(func(rxn): return rxn.type == Reaction.RxnType.DISLIKE).size())
	var comments = str(post.rxns.filter(func(rxn): return rxn.type == Reaction.RxnType.COMMENT).size())
	print("\tLikes: " + likes + ", Dislikes: " + dislikes + ", Comments: " + comments)

static func get_active_posts (currTime: int):
	var activePostCount = 0
	for post in posts:
		if currTime < post.endAt:
			activePostCount += 1
	return activePostCount
