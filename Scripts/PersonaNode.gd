extends StaticBody2D
class_name PersonaNode

const PT = preload("res://Scripts/PostTypes.gd")
const PERT = preload("res://Scripts/PersonaTypes.gd")
const pixelFont = preload("res://Fonts/PixelifySans-Regular.ttf")
const LikeFX = preload("res://FX/LikesFX.tscn")
const DownvotesFX = preload("res://FX/DownvotesFX.tscn")

const radius = 10
var isDragging = false
var id = -1
var buffer: Array[Vector2] = []
var persona: Persona

const SPAWN_OFFSET: int = -50

func init (person: Persona):
	persona = person
	$NodeCollisionShape2D/Sprite2D.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	$NodeCollisionShape2D/Sprite2D.texture = persona.display_pic
	# Set label below display picture
	$NodeCollisionShape2D/Label.text = persona.user_name
	$NodeCollisionShape2D/Label.position += Vector2(0,85)
	
	var labelSettings = LabelSettings.new()
	labelSettings.font = pixelFont
	labelSettings.font_color = Color.BLACK
	labelSettings.font_size = 16
	$NodeCollisionShape2D/Label.label_settings = labelSettings

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

func update_sprite_scale (factor: float):
	$NodeCollisionShape2D/Sprite2D.scale = Vector2(factor, factor)

func spawn_comment_sprite(position: Vector2):
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/image/icons/comment.png")
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var offset = Vector2(0, SPAWN_OFFSET)  # 30 pixels upward
	var spawn_position = position + offset
	sprite.position = spawn_position
	sprite.scale = Vector2(2.0, 2.0)
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

func deactivate_post_ui(postNode: Node):
	await get_tree().create_timer(2.0).timeout
	postNode.visible = false

func set_post(post: Post) -> void:
	if(persona and post):
		$NodeCollisionShape2D/Post.visible = true
		$NodeCollisionShape2D/Post/UserName.text = persona.user_name
		## TODO: choose a post from post bank based on the type and intent etc.
		$NodeCollisionShape2D/Post/PostMessage.text = PT.get_string_from_value(post.post_type)
		deactivate_post_ui($NodeCollisionShape2D/Post)

func update_feed(post: Post) -> void:
	# If self posted don't react, but make the post
	if(post.who_posted == id):
		set_post(post)
		return
	# This is where the persona reacts to the post
	print("Persona %s reacting to post of type %d by %d" % [persona.user_name, post.post_type, post.who_posted])
	var likedPostTypes: Array[int] = get_bitfield_post_types(persona)
	var dislikedPostTypes: Array[int] = get_bitfield_post_types(persona)
	if post.post_type in likedPostTypes:
		post.like(persona)
		print("\tSpawn like sprite at position %s" % position)
		$NodeCollisionShape2D/LikesFx.restart()
	elif post.post_type in dislikedPostTypes:
		post.dislike(persona)
		print("\tSpawn dislike sprite at position %s" % position)
		$NodeCollisionShape2D/DownvotesFX.restart()
	else:
		spawn_comment_sprite(position)
		print("\tPersona %s does not like or dislike post of type %d" % [persona.user_name, post.post_type])
		
	
	# todo: show likes and dislikes on the post
