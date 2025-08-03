extends Node
class_name GameManager

static var START_TIME: int
const START_TIME_OFFSET: int = 5 * 1000

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
		var activePosts = PostManager.get_active_posts(currTime)
		print("Active Posts: " + str(activePosts))
		prevTime = currTime
	PostManager.process(currTime)
	pass
