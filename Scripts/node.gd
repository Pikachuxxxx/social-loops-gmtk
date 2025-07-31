extends StaticBody2D
class_name MyNode

var isDragging = false
var id = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var center_position = Vector2(0,0)
	var radius = 10
	var circle_color = Color(1, 1, 1) # Red color (R, G, B, A)

	# Draw the circle
	draw_circle(center_position, radius, circle_color)

func intersect (pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = pos

	var result = space_state.intersect_point(query)
	return result.size() > 0 and result[0].collider == self

func move_node_if_dragging (pos: Vector2) -> bool:
	if isDragging:
		position = pos
	return isDragging
