extends StaticBody2D
class_name PersonaNode

"""
PostTypes are topics that they can post about
Persona -> [favouritePostTypes: [], hatedPostType: []]
When a node is created, 
	a persona is chosen (with a character sprite)
	add favourite post types
	random PostTypes are fetched
		until PostTypes for that persona reached a threshold
			add more PostType
			remove PostTypes that are hated
	the PostType threshold is decided by the time passed in the game 
	and if the games engagement is doing good or bad. 
	(more PostType threshold, easier the game is)
	(less PostType threshold, harder to combine people)

Things to worry about: What if user adds everyone in one group? 
- They always reach the right people anyways
- They might get hate (becuase users who dnt want to see the post will also get it) 
	on it so the satisfaction score will decrease, which is good, but engagement will also
	increase (sure this works?)
- We may need to add a cap on how many nodes can the post reach (if the above doesnt work)
"""

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
const POST_ALIVE_TIME: float = 5.0

enum IntersectMode {
	LINK,
	WIGGLE,
	CLICK,
}

func init (person: Persona):
	persona = person
	$NodeCollisionShape2D/Sprite2D.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	$NodeCollisionShape2D/Sprite2D.texture = persona.display_pic
	# Set label below display picture
	$NodeCollisionShape2D/Label.text = persona.user_name.left(persona.user_name.length() - 1)
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

func play_unlink_wiggle_sound():
	$NodeCollisionShape2D/SoundFX.stream = load("res://assets/audio/sfx/unlink_wiggle.wav")
	$NodeCollisionShape2D/SoundFX.play()

func play_link_sound():
	$NodeCollisionShape2D/SoundFX.stream = load("res://assets/audio/sfx/link.wav")
	$NodeCollisionShape2D/SoundFX.play()

func play_click_sound():
	$NodeCollisionShape2D/SoundFX.stream = load("res://assets/audio/sfx/click.wav")
	$NodeCollisionShape2D/SoundFX.play()

func intersect (pos: Vector2, mode: IntersectMode) -> bool:
	var space_state = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = pos

	var result = space_state.intersect_point(query)
	var did_intersect = false
	if result.size() > 0:
		did_intersect = result[0].collider == self
	if did_intersect:
		if mode == IntersectMode.LINK:
			play_link_sound()
		elif mode == IntersectMode.WIGGLE:
			play_unlink_wiggle_sound()
		elif mode == IntersectMode.CLICK:
			play_click_sound()
	return did_intersect

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

func get_bitfield_post_types(interests: int) -> Array[int]:
	var post_types: Array[int] = []
	for key in PT.POST_TYPE:
		if key == "MAX_POST_TYPES":
			continue
		var flag = PT.POST_TYPE[key]
		if interests & flag:
			post_types.append(flag)
	return post_types

func deactivate_post_ui(postNode: Node):
	await get_tree().create_timer(POST_ALIVE_TIME).timeout
	postNode.visible = false

func set_post(post: Post) -> void:
	if(persona and post):
		$NodeCollisionShape2D/Post.visible = true
		$NodeCollisionShape2D/Post/UserName.text = persona.user_name
		## TODO: choose a post from post bank based on the type and intent etc.
		$NodeCollisionShape2D/Post/PostMessage.text = PT.get_random_message(persona.persona_type, post.post_type)
		$NodeCollisionShape2D/Post/PostType.text = "[Debug]" + PT.get_string_from_value(post.post_type)
		deactivate_post_ui($NodeCollisionShape2D/Post)

func update_feed(post: Post, group: Group) -> void:
	# If self posted don't react, but make the post
	if(post.who_posted == id):
		set_post(post)
		return
	# This is where the persona reacts to the post
	print("Persona %s reacting to post of type %d by %d" % [persona.user_name, post.post_type, post.who_posted])
	var likedPostTypes: Array[int] = get_bitfield_post_types(persona.likes)
	var dislikedPostTypes: Array[int] = get_bitfield_post_types(persona.dislikes)
	print("post.post_type: %d" % post.post_type)
	print("likedPostTypes: %s" % str(likedPostTypes))
	print("dislikedPostTypes: %s" % str(dislikedPostTypes))
	if post.post_type in likedPostTypes:
		post.like(persona)
		print("\tSpawn like sprite at position %s" % position)
		$NodeCollisionShape2D/LikesFx.restart()
		$NodeCollisionShape2D/SoundFX.stream = load("res://assets/audio/sfx/like.wav")
		$NodeCollisionShape2D/SoundFX.play()
	elif post.post_type in dislikedPostTypes:
		post.dislike(persona)
		print("\tSpawn dislike sprite at position %s" % position)
		$NodeCollisionShape2D/DownvotesFX.restart()
		$NodeCollisionShape2D/SoundFX.stream = load("res://assets/audio/sfx/dislike.wav")
		$NodeCollisionShape2D/SoundFX.play()
