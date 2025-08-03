extends Node2D

var last_spawn_time: int = 0
const SPAWN_TIME: int = 25000 # 25 seconds
const NUM_SPAWN: int = 3 # Number of personas to spawn each time

const PERT = preload("res://Scripts/PersonaTypes.gd")
const IM = preload("res://Scripts/PersonaNode.gd")
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

			draw_line(points[0], points[1], group.get_group_color(), 3, false)

func create_random_persona() -> Persona:
	var persona : Persona = Persona.new()
	persona.persona_type = PERT.pick_random_persona_type()
	var dp = PERT.get_persona_pic(persona.persona_type)
	print(dp)
	persona.display_pic = load(dp)
	if(persona.persona_type == PERT.PERSONA_TYPE.GENERIC):
		persona.persona_type = PERT.get_random_prototype()

	var persona_type_str = PERT.PERSONA_TYPE.keys()[persona.persona_type]
	persona.user_name = PERT.get_random_username(persona_type_str)
	print(persona_type_str)
	persona.occupation = "None"
	persona.age = 20 + randi() % 30 # Random age between 20 and 50
	# random;y set random number of likes and dislikes
	persona.likes = 1 << (randi() % PERT.PERSONA_TYPE.MAX_PERSONA_TYPES)
	persona.dislikes = 1 << (randi() % PERT.PERSONA_TYPE.MAX_PERSONA_TYPES)
	# Randomly set drama, tolerance, and influence
	persona.drama = randf() * 2.0 - 1.0
	persona.tolerance = randf() * 2.0 - 1.0
	persona.influence = randf() * 2.0 - 1.0
	persona.variant_idx = 0

	var num_likes = randi() % PERT.PERSONA_TYPE.MAX_PERSONA_TYPES + 1
	var num_dislikes = randi() % PERT.PERSONA_TYPE.MAX_PERSONA_TYPES + 1

	for l in num_likes:
		var bit = 1 << (randi() % PERT.PERSONA_TYPE.MAX_PERSONA_TYPES)
		persona.likes |= bit

	for d in num_dislikes:
		var bit = 1 << (randi() % PERT.PERSONA_TYPE.MAX_PERSONA_TYPES)
		persona.dislikes |= bit
	return persona

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var count = 6
	var radius = 200.0
	var center = get_viewport_rect().size / 2.0
	for i in range(count):
		var angle = (2.0 * PI / count) * i
		var pos = center + Vector2(cos(angle), sin(angle)) * radius

		# randomly create a persona type
		var persona: Persona = create_random_persona()
		var node: PersonaNode = nodeScene.instantiate() as PersonaNode
		node.id = i
		node.position = pos
		persona.id = node.id
		node.init(persona)
		Globals.g_nodes.append(node)
		add_child(node)
	queue_redraw()
	zuck = get_tree().get_root().get_node("Node2D/ZuckAlg") as Zuck

func spawn_random_persona() -> void:
	var persona: Persona = create_random_persona()
	var node: PersonaNode = nodeScene.instantiate() as PersonaNode
	node.id = Globals.g_nodes.size()
	node.position = Vector2(randf() * get_viewport_rect().size.x, randf() * get_viewport_rect().size.y)
	persona.id = node.id
	node.init(persona)
	Globals.g_nodes.append(node)
	add_child(node)
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# every 10 seconds create 5 new personas, just check time and spawn them
	var now = Time.get_ticks_msec() 
	if now - last_spawn_time >= SPAWN_TIME:
		last_spawn_time = now
		for i in range(NUM_SPAWN):
			spawn_random_persona()

	zuck.process(delta)
	wiggle.process(delta, func ():
		# Wiggle detected
		for node in Globals.g_nodes:
			if node.isDragging:
				for group in Globals.g_groups:
					node.play_unlink_wiggle_sound()
					group.erase_node(node.id, node.update_feed)
	)

	for node in Globals.g_nodes:
		if node.isDragging:
			node.update_sprite_scale(2.4)
		else:
			node.update_sprite_scale(2)
	# update the groups score
	var totalEngagement: int = 0
	var totalLikes: int = 0
	for group in Globals.g_groups:
		totalEngagement += group.get_engagement_percentage()
		totalLikes += group.get_total_likes()
	if Globals.g_groups.size() > 0:
		var averageEngagement = totalEngagement / Globals.g_groups.size()
		$CanvasLayer/EngagementScore.text = "Total Engagement: " + str(averageEngagement) + "%"
	$CanvasLayer/TotalLikes.text = "Total Likes: " + str(totalLikes) + "❤️"
	$CanvasLayer/Followers.text = "Total Followers: " + str(Globals.g_nodes.size())

	# if totalEngagement is less than 0 then restart the entire game
	if totalEngagement <= 0:
		print("Total Engagement is less than 0, restarting the game")
		Globals.g_nodes.clear()
		Globals.g_groups.clear()
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var world_pos = get_global_mouse_position() #get_viewport().get_camera_2d().screen_to_world(event.position)
		# Move Globals.g_nodes around
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			for node in Globals.g_nodes:
				if node.intersect(world_pos, IM.IntersectMode.CLICK):
					node.dragOn()
					wiggle.init(world_pos)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			for node in Globals.g_nodes:
				node.dragOff()

		# Create group
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if not isGroupActive():
				for node in Globals.g_nodes:
					if node.intersect(world_pos, IM.IntersectMode.LINK):
						var group = GroupNode.new(true, func ():
							Utils.preprocess_groups(groupPairCount, Globals.g_groups)
							print(str(groupPairCount))
							for group in Globals.g_groups:
								print(str(group.nodeIds))
							pass
						)
						group.add_node_id(node.id, node.update_feed)
						Globals.g_groups.append(group)
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
				wiggle.on_move(mousePosition)
				queue_redraw()
		# GroupNode expansion
		if isGroupActive():
			for node in Globals.g_nodes:
				if node.intersect(mousePosition, IM.IntersectMode.LINK):
					Globals.g_groups[Globals.g_groups.size()-1].add_node_id(node.id, node.update_feed)
			queue_redraw()

func isGroupActive () -> bool:
	if Globals.g_groups.size() > 0:
		return Globals.g_groups[Globals.g_groups.size()-1].isInProgress
	return false
