extends StaticBody2D
class_name MyNode

const radius = 10

var isDragging = false
var id = -1

var buffer: Array[Vector2] = []

"""
func _draw() -> void:
	var font = ThemeDB.fallback_font
	var pos = Vector2(-6, -34)
	draw_string(font, pos, str(id))
	
func _ready() -> void:
	queue_redraw()
"""

func update_texture (texture):
	$NodeCollisionShape2D/Sprite2D.texture = texture

func dragOn ():
	isDragging = true

func dragOff ():
	isDragging = false

func intersect (pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = pos

	var result = space_state.intersect_point(query)
	return result.size() > 0 and result[0].collider == self

func move_node_if_dragging (pos: Vector2) -> bool:
	if isDragging:
		position = pos
	#queue_redraw()
	return isDragging
