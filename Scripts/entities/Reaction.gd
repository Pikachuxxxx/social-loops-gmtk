extends Node
class_name Reaction

enum RxnType {LIKE, DISLIKE, COMMENT, NEUTRAL}

var startAt: int
var type: RxnType = RxnType.LIKE
var comment: String = ""
var nodeId: int = 0
var commentSense: int = 0 # -1 negative, 0 neutral, 1 positive
var isTriggered: bool = false
