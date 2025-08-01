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
	pair.sort()
	return str(pair[0]) + "-" + str(pair[1])

static func get_adjacent_line (iter: int, count: int, firstPoint: Vector2, secondPoint: Vector2) -> Array[Vector2]:
	if count == 1:
		return [firstPoint, secondPoint]

	var offset = 4 + 2 # line_width + gap
	var size = count * offset - 1 # - gap
	var startDist = size/2

	# Perpendicular slope
	var n = -1 * (secondPoint.x - firstPoint.x)/(secondPoint.y - firstPoint.y)

	var length = sqrt(1 + n*n)

	var dmx = startDist / length
	var dmy = n * startDist / length

	var dx = offset / length
	var dy = n * offset / length

	return [
		Vector2(firstPoint.x - dmx + dx*(iter-1), firstPoint.y - dmy + dy*(iter-1)),
		Vector2(secondPoint.x - dmx + dx*(iter-1), secondPoint.y - dmy + dy*(iter-1))
	]
