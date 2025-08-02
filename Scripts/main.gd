extends Node2D

const nodeScene: PackedScene = preload("res://Scenes/node.tscn")
var nodes: Array[MyNode] = []
var groups: Array[Group] = []

var groupPairCount: Dictionary = {}

const groupColors: Array[Color] = [Color.GREEN, Color.BLUE, Color.ORANGE, Color.DEEP_PINK, Color.BLUE_VIOLET, Color.CRIMSON, Color.LIGHT_CORAL, Color.YELLOW, Color.RED, Color.GHOST_WHITE, Color.DEEP_SKY_BLUE, Color.DARK_SALMON, Color.DARK_ORANGE, Color.DARK_GREEN, Color.DARK_CYAN, Color.YELLOW_GREEN]
var mousePosition: Vector2 = Vector2(0,0)
var wiggle = Wiggle.new()

func _draw() -> void:
	var _groupPairCount = {}
	for group in groups:
		var groupNodeIds = group.nodeIds.duplicate()
		if group.isInProgress:
			groupNodeIds.append(-1) # Using -1 to get mouse position for now
		for i in range(groupNodeIds.size()):
			var nodeId = groupNodeIds[i]
			var nextNodeId = groupNodeIds[(i+1)%groupNodeIds.size()]

			var nodePosition = mousePosition if nodeId == -1 else nodes[nodeId].position
			var nextNodePosition = mousePosition if nextNodeId == -1 else nodes[nextNodeId].position

			var key = Utils.get_pair_key(nodeId, nextNodeId)
			if not _groupPairCount.has(key):
				_groupPairCount[key] = 0
			_groupPairCount[key] += 1

			var count = Utils.get_pair_count(groupPairCount, nodeId, nextNodeId)
			var points = Utils.get_adjacent_line(_groupPairCount[key], count, nodePosition, nextNodePosition)

			draw_line(points[0], points[1], groupColors[group.id], 3, false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var count = 6
	var radius = 200.0
	var center = get_viewport_rect().size / 2.0
	for i in range(count):
		var angle = (2.0 * PI / count) * i
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		var node: MyNode = nodeScene.instantiate() as MyNode
		node.id = i
		node.position = pos
		node.update_texture(UserGenerated.characterTextures[i])
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
					group.erase_node(node.id)
	)
	
	for node in nodes:
		if node.isDragging:
			node.update_sprite_scale(2.4)
		else:
			node.update_sprite_scale(2)

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
						var group = Group.new(true, func ():
							Utils.preprocess_groups(groupPairCount, groups)
							print(str(groupPairCount))
							for group in groups:
								print(str(group.nodeIds))
							pass
						)
						group.add_node_id(node.id)
						groups.append(group)
						queue_redraw()
						break
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if groups.size() > 0:
				for group in groups:
					if group.isInProgress == true:
						group.isInProgress = false
						if group.nodeIds.size() <= 1:
							groups.erase(group)
						break
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
