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
const PERT = preload("res://Scripts/PersonaTypes.gd")

const POST_START_OFFSET = 2 * 1000
const POST_MIN_END_OFFSET = 4 * 1000
const RXN_START_OFFSET = 1 * 1000
const RXN_TIME = 0.5 * 1000
const RXN_COMMENT_TIME = 1 * 1000
const RXN_COMMENT_READ_TIME = 1 * 1000 # Maybe calculate it dynamically

static var posts: Array[Post] = []

static func process(currTime: int) -> void:
	var activePostCount = get_active_posts_count(currTime)

	#print("Posts Active: " + str(activePostCount))
	if posts.size() == 0 and  currTime - GameManager.START_TIME > GameManager.START_TIME_OFFSET:
		print("Create first post")
		PostManager.generate_new_post(currTime)
		
	if activePostCount < 2 and currTime - GameManager.START_TIME > GameManager.START_TIME_OFFSET + POST_START_OFFSET + POST_MIN_END_OFFSET:
		PostManager.generate_new_post(currTime)

static func generate_rxns (postStartAt: int, type: int, rxnIds: Array[int]):
	var rxns: Array[Reaction] = []
	for rxnId in rxnIds:
		var rxnNode = Globals.get_persona_node(rxnId)
		var likesPost = type & rxnNode.persona.likes > 0
		var dislikesPost = type & rxnNode.persona.dislikes > 0
		var rxn = Reaction.new()
		rxn.startAt = postStartAt + RXN_START_OFFSET# + randi_range(0,4) * 1000
		rxn.nodeId = rxnNode.id
		if likesPost:
			rxn.type = Reaction.RxnType.LIKE
		elif dislikesPost:
			rxn.type = Reaction.RxnType.DISLIKE
		else:
			# try random, favouring towards a like
			rxn.type = Reaction.RxnType.NEUTRAL
		rxns.append(rxn)
		var commentTime = 0
		if randf_range(0,1) > 0.5:
			var commentRxn = Reaction.new()
			commentRxn.type = Reaction.RxnType.COMMENT
			commentRxn.nodeId = rxnNode.id
			commentRxn.startAt = rxn.startAt + RXN_COMMENT_TIME# + randi_range(0,4) * 1000
			commentRxn.comment = "Some comment"
			if likesPost:
				commentRxn.commentSense = 1
			elif dislikesPost:
				commentRxn.commentSense = -1
			else:
				commentRxn.commentSense = 0
			commentTime = commentRxn.startAt + RXN_COMMENT_READ_TIME
			rxns.append(rxn)
	return rxns

static func generate_new_post (currTime: int):
	print("Generating new post")
	var post = Post.new()
	post.startAt = currTime + POST_START_OFFSET + randi_range(0,4) * 1000

	var node = Globals.g_nodes[randi_range(0, Globals.g_nodes.size()-1)]
	while get_active_posts(currTime).map(func(p): return p.nodeId).has(node.id):
		node = Globals.g_nodes[randi_range(0, Globals.g_nodes.size()-1)]
	
	post.type = get_random_liked_index(node.persona.likes, PT.POST_TYPE.MAX_POST_TYPES)
	post.nodeId = node.id
	
	post.endAt = post.startAt + POST_MIN_END_OFFSET
	
	var reachableNodeIds = Globals.get_reachable_node_ids(post.nodeId)
	post.rxns.append_array(generate_rxns(post.startAt, post.type, reachableNodeIds))
	posts.append(post)
	
	print("Post start: " + str(post.startAt) + ", end: " + str(post.endAt))
	var likes = str(post.rxns.filter(func(rxn): return rxn.type == Reaction.RxnType.LIKE).size())
	var dislikes = str(post.rxns.filter(func(rxn): return rxn.type == Reaction.RxnType.DISLIKE).size())
	var comments = str(post.rxns.filter(func(rxn): return rxn.type == Reaction.RxnType.COMMENT).size())
	print("\tLikes: " + likes + ", Dislikes: " + dislikes + ", Comments: " + comments)

static func update_rxns () -> void:
	var currTime: int = Time.get_ticks_msec()
	var activePosts = get_active_posts(currTime)
	for activePost in activePosts:
		var reachableNodeIds: Array[int] = Globals.get_reachable_node_ids(activePost.nodeId)
		
		var reachedNodeIds: Array[int] = []
		for rxn in activePost.rxns:
			reachedNodeIds.append(rxn.nodeId)
		
		for rxn in activePost.rxns:
			if reachableNodeIds.has(rxn.nodeId):
				reachableNodeIds.erase(rxn.nodeId)
				reachedNodeIds.erase(rxn.nodeId)
		
		# Removing rxns that are not reachable
		for rxn in activePost.rxns:
			if reachableNodeIds.has(rxn.nodeId) and currTime < rxn.endAt:
				activePost.rxns.erase(rxn)
		
		# Adding new rxns
		activePost.rxns.append_array(generate_rxns(currTime, activePost.type, reachableNodeIds))
	pass

static func get_active_posts_count (currTime: int) -> int:
	var activePostCount = 0
	for post in posts:
		if currTime < post.endAt:
			activePostCount += 1
	return activePostCount

static func get_active_posts (currTime: int) -> Array[Post]:
	var activePosts: Array[Post] = []
	for post in posts:
		if currTime < post.endAt:
			activePosts.append(post)
	return activePosts
	
# Vector2(enagement, satisfaction)
static func _debug_get_global_metrics () -> int:
	var totalLikes: int = 0
	for post in posts:
		if post.isTriggered:
			var likes = 0
			var comments = 0
			var positiveComments = 0
			for rxn in post.rxns:
				if rxn.isTriggered:
					if rxn.type == Reaction.RxnType.LIKE:
						likes += 1
					elif rxn.type == Reaction.RxnType.COMMENT:
						comments += 1
						positiveComments += rxn.commentSense
			totalLikes += likes + positiveComments * 2
	return totalLikes

# Vector2(enagement, satisfaction)
static func get_global_metrics () -> Vector2:
	var pastTime = Time.get_ticks_msec() - 30 * 1000 # 10 seconds window, all posts before that become irrelevant
	var engagement: int = 0
	var totalLikes: int = 0
	for post in posts:
		if post.endAt > pastTime and post.isTriggered:
			var likes = 0
			var dislikes = 0
			var comments = 0
			var positiveComments = 0
			for rxn in post.rxns:
				if rxn.isTriggered:
					if rxn.type == Reaction.RxnType.LIKE:
						likes += 1
					elif rxn.type == Reaction.RxnType.DISLIKE:
						dislikes += 1
					elif rxn.type == Reaction.RxnType.COMMENT:
						comments += 1
						positiveComments += rxn.commentSense
			engagement += likes + dislikes + comments * 2
			totalLikes += likes + positiveComments * 2
	var satisfaction: float = float(totalLikes)/engagement if engagement > 0 else 0
	return Vector2(engagement, satisfaction)
