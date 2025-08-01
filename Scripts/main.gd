extends Node2D

const nodeScene: PackedScene = preload("res://Scenes/node.tscn")
var nodes: Array[MyNode] = []
var groups: Array[Group] = []

var groupPairCount: Dictionary = {}

const groupColors: Array[Color] = [Color.GREEN, Color.BLUE, Color.ORANGE, Color.DEEP_PINK, Color.BLUE_VIOLET]
var mousePosition: Vector2 = Vector2(0,0)
var wiggle = Wiggle.new()

func _draw() -> void:
	for gid in range(groups.size()):
		var group = groups[gid]
		var groupNodeIds = group.nodeIds.duplicate()
		if group.isInProgress:
			groupNodeIds.append(-1) # Using -1 to get mouse position for now
		for i in range(groupNodeIds.size()):
			var nodeId = groupNodeIds[i]
			var nextNodeId = groupNodeIds[(i+1)%groupNodeIds.size()]
			
			var nodePosition = mousePosition if nodeId == -1 else nodes[nodeId].position
			var nextNodePosition = mousePosition if nextNodeId == -1 else nodes[nextNodeId].position
			
			draw_line(nodePosition, nextNodePosition, groupColors[gid], 1, true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var count = 5
	var radius = 200.0
	var center = get_viewport_rect().size / 2.0
	for i in range(count):
		var angle = (2.0 * PI / count) * i
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		var node: MyNode = nodeScene.instantiate() as MyNode
		node.id = i
		node.position = pos
		nodes.append(node)
		add_child(node)
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wiggle.process(delta, func ():
		# Wiggle detected
		for node in nodes:
			if node.isDragging:
				for group in groups:
					group.nodeIds.erase(node.id)
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Move nodes around
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			for node in nodes:
				if node.intersect(event.position):
					node.dragOn()
					wiggle.init(event.position)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			for node in nodes:
				node.dragOff()
			
		# Create group
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if not isGroupActive():
				for node in nodes:
					if node.intersect(event.position):
						var group = Group.new(true)
						group.add_node_id(node.id)
						groups.append(group)
						queue_redraw()
						break
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if groups.size() > 0:
				groups[groups.size()-1].isInProgress = false
				queue_redraw()
	elif event is InputEventMouseMotion:
		mousePosition = event.position
		# Node dragging
		for node in nodes:
			if node.move_node_if_dragging(event.position):
				var groupNodeVector = Utils.is_node_touching_group(node, nodes, groups)
				if groupNodeVector.x != -1:
					var group = groups[groupNodeVector.x]
					var insertIdx = groupNodeVector.y+1
					group.insert_node_id(insertIdx, node.id)
				wiggle.on_move(event.position)
				queue_redraw()
		# Group expansion
		if isGroupActive():
			for node in nodes:
				if node.intersect(event.position):
					groups[groups.size()-1].add_node_id(node.id)
			queue_redraw()

func isGroupActive () -> bool:
	if groups.size() > 0:
		return groups[groups.size()-1].isInProgress
	return false
