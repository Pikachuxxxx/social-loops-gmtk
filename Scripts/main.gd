extends Node2D

const PERT = preload("res://Scripts/PersonaTypes.gd")
const nodeScene: PackedScene = preload("res://Scenes/persona_node.tscn")
var zuck: Zuck

var groupPairCount: Dictionary = {}


var mousePosition: Vector2 = Vector2(0,0)
var wiggle = Wiggle.new()

func _draw() -> void:
	var _groupPairCount = {}
	for group in Globals.g_groups:
		var groupNodeIds = group.nodeIds.duplicate()
		if group.isInProgress:
			groupNodeIds.append(-1) # Using -1 to get mouse position for now
		for i in range(groupNodeIds.size()):
			var nodeId = groupNodeIds[i]
			var nextNodeId = groupNodeIds[(i+1)%groupNodeIds.size()]

			var nodePosition = mousePosition if nodeId == -1 else Globals.g_nodes[nodeId].position
			var nextNodePosition = mousePosition if nextNodeId == -1 else Globals.g_nodes[nextNodeId].position

			var key = Utils.get_pair_key(nodeId, nextNodeId)
			if not _groupPairCount.has(key):
				_groupPairCount[key] = 0
			_groupPairCount[key] += 1

			var count = Utils.get_pair_count(groupPairCount, nodeId, nextNodeId)
			var points = Utils.get_adjacent_line(_groupPairCount[key], count, nodePosition, nextNodePosition)

			draw_line(points[0], points[1], Globals.g_colors[group.id], 3, false)

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
		var node: PersonaNode = nodeScene.instantiate() as PersonaNode
		node.id = i
		node.position = pos
		persona.id = node.id
		node.init(persona)
		Globals.g_nodes.append(node)
		add_child(node)
	queue_redraw()
	zuck = get_tree().get_root().get_node("Node2D/ZuckAlg") as Zuck
	GameManager.init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GameManager.process()
	#zuck.process(delta)
	wiggle.process(delta, func ():
		# Wiggle detected
		# Globals.g_nodes.filter()
		for node in Globals.g_nodes:
			if node.isDragging:
				var groups = Globals.get_node_groups(node.id)
				if groups.size() == 1:
					groups[0].erase_node(node.id, node.update_feed)
				elif groups.size() > 1:
					PostManager.update_rxns()
					Globals.showBackdrop = true
					Globals.updatingNodeId = node.id
					$Backdrop/RemoveNodeFromGroups.queue_redraw()
	)

	for node in Globals.g_nodes:
		if node.isDragging:
			node.update_sprite_scale(2.4)
		else:
			node.update_sprite_scale(2)
			
	var metrics2 = PostManager.get_global_metrics()
	$CanvasLayer2/MarginContainer/Label.text = "Engagement: " + str(metrics2.x) + "        Satisfaction: %.2f" % metrics2.y
	
	if Globals.showBackdrop:
		$Backdrop.show()
	else:
		$Backdrop.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var world_pos = get_global_mouse_position() #get_viewport().get_camera_2d().screen_to_world(event.position)
		# Move Globals.g_nodes around
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			for node in Globals.g_nodes:
				if node.intersect(world_pos):
					node.dragOn()
					wiggle.init(world_pos)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			for node in Globals.g_nodes:
				node.dragOff()

		# Create group
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if not isGroupActive():
				for node in Globals.g_nodes:
					if node.intersect(world_pos):
						var group = GroupNode.new(true, func ():
							Utils.preprocess_groups(groupPairCount, Globals.g_groups)
							#print(str(groupPairCount))
							#for group in Globals.g_groups:
								#print(str(group.nodeIds))
							pass
						)
						group.add_node_id(node.id, node.update_feed)
						Globals.g_groups.append(group)
						PostManager.update_rxns()
						queue_redraw()
						break
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if Globals.g_groups.size() > 0:
				for group in Globals.g_groups:
					if group.isInProgress == true:
						group.isInProgress = false
						if group.nodeIds.size() <= 1:
							Globals.g_groups.erase(group)
						break
				queue_redraw()
	elif event is InputEventMouseMotion:
		mousePosition = get_global_mouse_position() #get_viewport().get_camera_2d().screen_to_world(event.position)
		# Node dragging
		for node in Globals.g_nodes:
			if node.move_node_if_dragging(mousePosition):
				var groupNodeVector = Utils.is_node_touching_group(node, Globals.g_nodes, Globals.g_groups)
				if groupNodeVector.x != -1:
					var group = Globals.g_groups[groupNodeVector.x]
					var insertIdx = groupNodeVector.y+1
					group.insert_node_id(insertIdx, node.id, node.update_feed)
					PostManager.update_rxns()
				wiggle.on_move(mousePosition)
				queue_redraw()
		# GroupNode expansion
		if isGroupActive():
			for node in Globals.g_nodes:
				if node.intersect(mousePosition):
					Globals.g_groups[Globals.g_groups.size()-1].add_node_id(node.id, node.update_feed)
			queue_redraw()

func isGroupActive () -> bool:
	if Globals.g_groups.size() > 0:
		return Globals.g_groups[Globals.g_groups.size()-1].isInProgress
	return false
