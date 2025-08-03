extends Node
class_name Reaction

enum RxnType {LIKE, DISLIKE, COMMENT}

var startAt: int
var type: RxnType = RxnType.LIKE
var comment: String = ""
var nodeId: int = 0
