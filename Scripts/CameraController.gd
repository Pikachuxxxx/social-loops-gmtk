extends Camera2D

var dragging := false
var zoom_step := 0.1
var min_zoom := 0.2
var max_zoom := 5.0

func _input(event):
	# Middle mouse button drag to pan
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom

	# Scroll wheel to zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom = clamp(zoom - Vector2(zoom_step, zoom_step), Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom = clamp(zoom + Vector2(zoom_step, zoom_step), Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
