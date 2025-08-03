extends Resource
class_name Reaction

enum RxnType {LIKE, DISLIKE, COMMENT, NEUTRAL}

var type: RxnType = RxnType.LIKE
var comment: String = ""
var nodeId: int = 0
var commentSense: int = 0 # -1 negative, 0 neutral, 1 positive
