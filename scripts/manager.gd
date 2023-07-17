extends Node

var screen_size = DisplayServer.screen_get_size()
var window_size

func _ready():
	DisplayServer.window_set_size(screen_size/2)
	window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_position(screen_size*0.5 - window_size*0.5)

func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		toggle_fullscreen()
	if Input.is_action_just_pressed("retry"):
		SceneTransition.change_scene_to(get_tree().current_scene.scene_file_path)
	
	
func toggle_fullscreen():
	if !DisplayServer.window_get_mode():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
