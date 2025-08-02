extends StaticBody2D
class_name PersonaNode

const PT = preload("res://Scripts/PostTypes.gd")
const PERT = preload("res://Scripts/PersonaTypes.gd")

const radius = 10
var isDragging = false
var id = -1
var buffer: Array[Vector2] = []
var persona: Persona

const SPAWN_OFFSET: int = -50

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

func spawn_like_sprite(position: Vector2):
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/image/icons/like.png")
	var offset = Vector2(0, SPAWN_OFFSET)  # 30 pixels upward
	var spawn_position = position + offset
	sprite.position = spawn_position
	get_tree().current_scene.add_child(sprite)
	# Wait 2 seconds then free the sprite
	await get_tree().create_timer(2.0).timeout
	sprite.queue_free()

func spawn_dislike_sprite(position: Vector2):
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/image/icons/downvote.png")
	var offset = Vector2(0, SPAWN_OFFSET)  # 30 pixels upward
	var spawn_position = position + offset
	sprite.position = spawn_position
	get_tree().current_scene.add_child(sprite)
	# Wait 2 seconds then free the sprite
	await get_tree().create_timer(2.0).timeout
	sprite.queue_free()

func spawn_comment_sprite(position: Vector2):
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/image/icons/comment.png")
	var offset = Vector2(0, SPAWN_OFFSET)  # 30 pixels upward
	var spawn_position = position + offset
	sprite.position = spawn_position
	get_tree().current_scene.add_child(sprite)
	# Wait 2 seconds then free the sprite
	await get_tree().create_timer(2.0).timeout
	sprite.queue_free()

func get_bitfield_post_types(persona: Persona) -> Array[int]:
	var liked_post_types: Array[int] = []
	for key in PT.POST_TYPE:
		if key == "MAX_POST_TYPES":
			continue
		var flag = PT.POST_TYPE[key]
		if persona.likes & flag:
			liked_post_types.append(flag)
	return liked_post_types

func update_feed(post: Post) -> void:
	# This is where the persona reacts to the post
	print("Persona %s reacting to post of type %d by %d" % [persona.user_name, post.post_type, post.who_posted])
	var likedPostTypes: Array[int] = get_bitfield_post_types(persona)
	var dislikedPostTypes: Array[int] = get_bitfield_post_types(persona)
	if post.post_type in likedPostTypes:
		post.like(persona)
		print("Spawn like sprite at position %s" % position)
		spawn_like_sprite(position)
	elif post.post_type in dislikedPostTypes:
		post.dislike(persona)
		print("Spawn dislike sprite at position %s" % position)
		spawn_dislike_sprite(position)
	else:
		spawn_comment_sprite(position)
		print("Persona %s does not like or dislike post of type %d" % [persona.user_name, post.post_type])
		
	
	# todo: show likes and dislikes on the post
