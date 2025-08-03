extends Node
class_name GameManager

static var START_TIME: int
const START_TIME_OFFSET: int = 5 * 1000 # 5 seconds before the first post is created

static var prevTime: int

static func init () -> void:
	START_TIME = Time.get_ticks_msec()
	prevTime = START_TIME
	print(str(START_TIME))
	for i in range(10):
		print(str(randf_range(0,1)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
static func process() -> void:
	var currTime = Time.get_ticks_msec()
	if currTime - prevTime > 3 * 1000:
		print(currTime)
		var activePostsCount = PostManager.get_active_posts_count(currTime)
		print("Active Posts: " + str(activePostsCount))
		var metrics2 = PostManager.get_global_metrics()
		var totalLikes = PostManager._debug_get_global_metrics()
		print("Engagement: " + str(metrics2.x) + ", Satisfaction: " + str(metrics2.y) + ", Total Likes: " + str(totalLikes))
		prevTime = currTime
	
	PostManager.process(currTime)
	
	var activePosts: Array[Post] = PostManager.get_active_posts(currTime)
	for activePost in activePosts:
		if currTime > activePost.startAt and !activePost.isTriggered:
			activePost.isTriggered = true
			var node = Globals.get_persona_node(activePost.nodeId)
			
		for rxn in activePost.rxns:
			if currTime > rxn.startAt and !rxn.isTriggered:
				rxn.isTriggered = true
				var rxnNode = Globals.get_persona_node(rxn.nodeId)
				if rxn.type == Reaction.RxnType.LIKE:
					rxnNode.animate_likes()
				elif rxn.type == Reaction.RxnType.DISLIKE:
					rxnNode.animate_dislikes()
				elif rxn.type == Reaction.RxnType.COMMENT:
					rxnNode.animate_comment()
