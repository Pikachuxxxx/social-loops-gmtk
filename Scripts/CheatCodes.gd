extends Node2D

var konami_code = ["up", "up", "down", "down", "left", "right", "left", "right"]
var input_history = []
var konami_length = konami_code.size()

# String-based cheat codes
var cheat_code_strings = {
	"zucksucks": "_activate_zuck_hack",
	"snoopdogg": "_activate_snoopdogg_hack",
	"eminem": "_activate_eminem_hack"
}
var typed_buffer = ""
var max_typed_length = 20 # Max length to buffer for code detection


func _input(event):
	# Sequence-based code (Konami code)
	if event is InputEventKey and event.pressed and not event.echo:
		var key = event.as_text().to_lower()
		print(key)  # Debug print to see the key pressed
		input_history.append(key)
		if input_history.size() > konami_length:
			input_history.pop_front()
		if input_history == konami_code:
			activate_debug_hacks()

		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_check_for_cheat_strings()
			typed_buffer = ""  # Always clear after Enter
		elif key.length() == 1 and key.is_valid_identifier():
			typed_buffer += key
			if typed_buffer.length() > max_typed_length:
				typed_buffer = typed_buffer.right(max_typed_length)

func _check_for_cheat_strings():
	print(typed_buffer)
	for code in cheat_code_strings.keys():
		if typed_buffer.to_lower().ends_with(code):
			var method_name = cheat_code_strings[code]
			if has_method(method_name):
				call(method_name)
			else:
				print("Cheat code detected: %s (no handler found)" % code)
			typed_buffer = "" # clear buffer after activation

func activate_debug_hacks():
	print("Konami code entered! Debug hacks enabled!")

func _activate_zuck_hack():
	print("Cheat code 'ZuckSucks' entered! Unlocking Zuck debug hacks!")
	Globals.g_EnableDebugPostTypes = !Globals.g_EnableDebugPostTypes  # Toggle debug post types

func _activate_snoopdogg_hack():
	print("Cheat code 'SnoopDogg' entered! Unlocking Snoop Dogg mode!")

func _activate_eminem_hack():
	print("Cheat code 'Eminem' entered! Infinite rap battles enabled!")
