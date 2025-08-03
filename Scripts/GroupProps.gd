extends Resource
class_name GroupProps

var current_post: Post
var engagement: float = 0.0
var total_likes: int = 0
var total_dislikes: int = 0
var comment_decay: float = 0.0
var harmony: float
var drama: float
var liked_posts: int = 0
var disliked_posts: int = 0
var color: Color
var rxns: Array[Reaction] = []
var total_posts: int = 0

const ENGAGEMENT_DISLIKE_FACTOR: float = 0.5
const ENGAGEMENT_LIKE_FACTOR: float = 1.0
const ENGAGEMENT_COMMENT_DECAY: float = 0.1

func add_reaction(post: Post) -> void:
	total_posts += 1
	var rxn: Reaction = post.get_last_rxn()
	if rxn and not rxns.has(rxn):
		print("Adding reaction %s to group" % [rxn.type])
		if rxn.type == Reaction.RxnType.LIKE:
			total_likes += 1
			liked_posts |= post.post_type
		elif rxn.type == Reaction.RxnType.DISLIKE:
			total_dislikes += 1
			disliked_posts |= post.post_type
		elif rxn.type == Reaction.RxnType.COMMENT:
			comment_decay += ENGAGEMENT_COMMENT_DECAY
		rxns.append(rxn)
	calculate_engagement()

func calculate_engagement() -> void:
	if total_posts > 0:
		engagement = (
			(total_likes * ENGAGEMENT_LIKE_FACTOR) -
			(total_dislikes * ENGAGEMENT_DISLIKE_FACTOR) -
			comment_decay
		) / total_posts
		print("Calculated engagement: %f" % engagement, "Total Likes: %d, Total Dislikes: %d, Comment Decay: %f" % [total_likes, total_dislikes, comment_decay])
	else:
		engagement = 0.0
