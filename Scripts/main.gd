extends Node2D

const PERT = preload("res://Scripts/PersonaTypes.gd")
const g_nodescene: PackedScene = preload("res://Scenes/persona_node.tscn")
var g_nodes: Array[PersonaNode] = []
var g_groups: Array[GroupNode] = []
var zuck: Zuck

var groupPairCount: Dictionary = {}
#const maxg_groups = 7 # just to avoid any crashes for now and maintain perf
const groupColors: Array[Color] = [Color.GREEN, Color.BLUE, Color.ORANGE, Color.DEEP_PINK, Color.BLUE_VIOLET, Color.CRIMSON, Color.LIGHT_CORAL]
var mousePosition: Vector2 = Vector2(0,0)
var wiggle = Wiggle.new()

func _draw() -> void:
	var _groupPairCount = {}
	for group in g_groups:
		var groupNodeIds = group.nodeIds.duplicate()
		if group.isInProgress:
			groupNodeIds.append(-1) # Using -1 to get mouse position for now
		for i in range(groupNodeIds.size()):
			var nodeId = groupNodeIds[i]
			var nextNodeId = groupNodeIds[(i+1)%groupNodeIds.size()]

			var nodePosition = mousePosition if nodeId == -1 else g_nodes[nodeId].position
			var nextNodePosition = mousePosition if nextNodeId == -1 else g_nodes[nextNodeId].position

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
		var personaResourceVariants : Array = PERT.PERSONA_TYPE_RESOURCES[i]
		# TOD: In future we can randomly pick a variant
		var personaResVariant = personaResourceVariants[0];
		var persona: Persona = load(personaResVariant)
		var node: PersonaNode = g_nodescene.instantiate() as PersonaNode
		node.id = i
		node.position = pos
		persona.id = node.id
		node.init(persona)
		g_nodes.append(node)
		add_child(node)
	queue_redraw()
	zuck = get_tree().get_root().get_node("Node2D/ZuckAlg") as Zuck

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	zuck.process(delta, g_groups, g_nodes)
	wiggle.process(delta, func ():
		# Wiggle detected
		for node in g_nodes:
			if node.isDragging:
				for group in g_groups:
					group.erase_node(node.id)
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Move g_nodes around
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			for node in g_nodes:
				if node.intersect(event.position):
					node.dragOn()
					wiggle.init(event.position)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			for node in g_nodes:
				node.dragOff()

		# Create group
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if not isGroupActive():
				for node in g_nodes:
					if node.intersect(event.position):
						var group = GroupNode.new(true, func ():
							Utils.preprocess_groups(groupPairCount, g_groups)
							print(str(groupPairCount))
							for group in g_groups:
								print(str(group.nodeIds))
							pass
						)
						group.add_node_id(node.id)
						g_groups.append(group)
						queue_redraw()
						break
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if g_groups.size() > 0:
				for group in g_groups:
					if group.isInProgress == true:
						group.isInProgress = false
						if group.nodeIds.size() <= 1:
							g_groups.erase(group)
						break
				queue_redraw()
	elif event is InputEventMouseMotion:
		mousePosition = event.position
		# Node dragging
		for node in g_nodes:
			if node.move_node_if_dragging(event.position):
				var groupNodeVector = Utils.is_node_touching_group(node, g_nodes, g_groups)
				if groupNodeVector.x != -1:
					var group = g_groups[groupNodeVector.x]
					var insertIdx = groupNodeVector.y+1
					group.insert_node_id(insertIdx, node.id)
				wiggle.on_move(event.position)
				queue_redraw()
		# GroupNode expansion
		if isGroupActive():
			for node in g_nodes:
				if node.intersect(event.position):
					g_groups[g_groups.size()-1].add_node_id(node.id)
			queue_redraw()

func isGroupActive () -> bool:
	if g_groups.size() > 0:
		return g_groups[g_groups.size()-1].isInProgress
	return false
