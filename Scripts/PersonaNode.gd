extends StaticBody2D
class_name PersonaNode

const radius = 10
var isDragging = false
var id = -1
var buffer: Array[Vector2] = []
var persona: Persona

func init (person: Persona):
	persona = person
	$NodeCollisionShape2D/Sprite2D.texture = persona.display_pic
	$NodeCollisionShape2D/Label.text = persona.user_name

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
	return isDragging
