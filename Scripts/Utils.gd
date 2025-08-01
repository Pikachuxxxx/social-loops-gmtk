extends Node2D
class_name Utils

static func perpendicular_distance(point: Vector2, line_first_point: Vector2, line_second_point: Vector2) -> float:
	var px = point.x
	var py = point.y
	
	var x1 = line_first_point.x
	var y1 = line_first_point.y
	
	var x2 = line_second_point.x
	var y2 = line_second_point.y
	
	var dx = x2 - x1
	var dy = y2 - y1
	var len2 = dx*dx + dy*dy
	if len2 == 0.0:
		return -1.0  # segment is a point

	var t = ((px - x1)*dx + (py - y1)*dy) / len2
	if t <= 0.0 or t >= 1.0:
		return -1.0  # projection at or beyond endpoints

	var proj_x = x1 + t * dx
	var proj_y = y1 + t * dy
	return sqrt((px - proj_x)*(px - proj_x) + (py - proj_y)*(py - proj_y))

# Uses Vector2 to return gId and nId
# nId is after which node in the group is the new node to be added
static func is_node_touching_group (draggingNode: MyNode, nodes: Array[MyNode], groups: Array[Group]) -> Vector2:
	var point = draggingNode.position
	print("Checking if node is touching group")
	for gid in range(groups.size()):
		var group = groups[gid]
		if group.nodeIds.has(draggingNode.id):
			continue
		for nId in range(group.nodeIds.size()):
			var nodeId = group.nodeIds[nId]
			var nextNodeId = group.nodeIds[(nId+1)%group.nodeIds.size()]
			
			var firstNodePos = nodes[nodeId].position
			var secondNodePos = nodes[nextNodeId].position
			var dist = perpendicular_distance(point, firstNodePos, secondNodePos)
			#print("Dist: " + str(dist) + ", gid: " + str(gid) + " " + str(point) + " ? " + str(firstNodePos) + ", " + str(secondNodePos))
			if dist != -1 and dist <= draggingNode.radius:
				return Vector2(gid, nId)
	return Vector2(-1, -1)

static func preprocess_groups(pairsCount: Dictionary, groups: Array[Group]) -> void:
	pairsCount.clear()
	for group in groups:
		var n = group.nodeIds.size()
		for i in range(n):
			var a = group.nodeIds[i]
			var b = group.nodeIds[(i + 1) % n]
			
			var key = get_pair_key(a, b)
			
			pairsCount[key] = pairsCount.get(key, 0) + 1

static func get_pair_count(pairsCount: Dictionary, a: int, b: int) -> int:
	return pairsCount.get(get_pair_key(a, b), 0)

static func get_pair_key (a: int, b: int):
	var pair = [a,b]
	return str(pair[0]) + "-" + str(pair[1])
