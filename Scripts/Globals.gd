extends Node

const pixelFont = preload("res://Fonts/PixelifySans-Regular.ttf")

var g_nodes: Array[PersonaNode] = []
var g_groups: Array[GroupNode] = []
const g_colors: Array[Color] = [Color.GREEN, Color.BLUE, Color.ORANGE, Color.DEEP_PINK, Color.BLUE_VIOLET, Color.CRIMSON, Color.LIGHT_CORAL, Color.YELLOW, Color.RED, Color.GHOST_WHITE, Color.DEEP_SKY_BLUE, Color.DARK_SALMON, Color.DARK_ORANGE, Color.DARK_GREEN, Color.DARK_CYAN, Color.YELLOW_GREEN]

# Using this for a quick solve
var updatingNodeId: int = 0
var showBackdrop: bool = false

func get_persona_node (nid: int) -> PersonaNode:
	for node in g_nodes:
		if node.id == nid:
			return node
	return null

func get_reachable_node_ids (nid: int)-> Array[int]:
	var reachableNodeIds: Array[int] = []
	for group in g_groups:
		if group.nodeIds.has(nid):
			for rnid in group.nodeIds:
				if rnid != nid and !reachableNodeIds.has(rnid):
					reachableNodeIds.append(rnid)
	return reachableNodeIds

func get_node_groups (nid: int) -> Array[GroupNode]:
	var groups: Array[GroupNode] = []
	for group in g_groups:
		if group.nodeIds.has(nid):
			groups.append(group)
	return groups
