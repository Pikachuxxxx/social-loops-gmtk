extends Node
class_name Wiggle

@export var wiggle_threshold := 5  # Number of direction changes needed to trigger
@export var wiggle_time_window := 0.2  # Seconds within which wiggles must happen

var last_mouse_position := Vector2.ZERO
var direction_changes := 0
var direction := 0  # -1, 0, 1
var wiggle_timer := 0.0

func init (pos: Vector2):
	last_mouse_position = pos
	direction_changes = 0
	wiggle_timer = 0.0
	
func on_move (pos: Vector2):
	var current_pos = pos
	var delta = current_pos - last_mouse_position

	# Detect wiggle: Change in X direction
	var current_direction = sign(delta.x)
	if current_direction != 0 and current_direction != direction:
		direction_changes += 1
		direction = current_direction
		wiggle_timer = 0.0  # reset timer each change

	last_mouse_position = current_pos

func process (delta, on_wiggle: Callable):
	wiggle_timer += delta
	if wiggle_timer > wiggle_time_window:
		direction_changes = 0  # Reset if too slow
		wiggle_timer = 0.0

	if direction_changes >= wiggle_threshold:
		on_wiggle.call()
