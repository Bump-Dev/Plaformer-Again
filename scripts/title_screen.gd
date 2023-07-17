extends Control

func _ready():
	$HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayButton.grab_focus()

func _on_play_button_pressed():
	SceneTransition.change_scene_to("res://scenes/levels/0.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_settings_button_pressed():
	Manager.toggle_fullscreen()
