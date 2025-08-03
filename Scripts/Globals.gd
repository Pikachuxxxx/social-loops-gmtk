extends Node

var g_nodes: Array[PersonaNode] = []
var g_groups: Array[GroupNode] = []

func get_persona_node (nid: int) -> PersonaNode:
	for node in g_nodes:
		if node.id == nid:
			return node
	return null
