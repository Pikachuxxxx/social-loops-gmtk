extends Node2D
class_name RemoveFromGroup

@export var mainNode: Node2D

const BUTTON_WIDTH = 175
const BUTTON_HEIGHT = 60

var removeNodes: Array[RemoveNode] = []

func draw_group (pos: Vector2, color: Color) -> void:
	draw_rect(Rect2(pos-Vector2(10,(BUTTON_HEIGHT/2)+5), Vector2(BUTTON_WIDTH+10, BUTTON_HEIGHT-8)), Color.NAVY_BLUE)
	
	var textWidth = Globals.pixelFont.get_string_size("x", 0, -1, 40)
	draw_string(Globals.pixelFont, pos, "x", 0, -1, 40, Color.RED)
	
	pos += Vector2(45, 0)
	draw_circle(pos-Vector2(0,10), 10, color)
	draw_string(Globals.pixelFont, pos+Vector2(20,0), "Group", 0, -1, 34, Color.WHITE)

func _draw () -> void:
	var wSize: Vector2i = DisplayServer.screen_get_size()
	var center: Vector2 = (wSize/2) - Vector2i(320, 220)
	#var rectPos = Vector2(center.x, center.y)
	#var rectSize = 
	#if Globals.updatingNodeId != null:
	if Globals.updatingNodeId != null:
		removeNodes.clear()
		var groups = Globals.get_node_groups(Globals.updatingNodeId)
		var overallHeight = BUTTON_HEIGHT * groups.size()
		var startPos = center - Vector2(BUTTON_WIDTH/2, overallHeight/2)
		var pos = startPos
		for group in groups:
			var removeNode = RemoveNode.new()
			removeNode.group = group
			removeNode.rectangle = Rect2(pos-Vector2(10,(BUTTON_HEIGHT/2)+5), Vector2(BUTTON_WIDTH+10, BUTTON_HEIGHT-8))
			removeNodes.append(removeNode)
			draw_group(pos, Globals.g_colors[group.id])
			pos.y += BUTTON_HEIGHT
		#draw_rect(Rect2(startPos, Vector2(BUTTON_WIDTH, BUTTON_HEIGHT)), Color.WHITE)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			for removeNode in removeNodes:
				print(removeNode.rectangle)
				print(event.position)
				if removeNode.rectangle.has_point(event.position):
					removeNode.group.erase_node(Globals.updatingNodeId, func(): pass)
					Globals.showBackdrop = false
					mainNode.queue_redraw()
