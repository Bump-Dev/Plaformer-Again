extends Area2D

@export_dir var level_dir
var next_scene
var player:CharacterBody2D

func _process(delta):
	modulate.h += 0.01
	if player != null:
		player.modulate = modulate

func _on_body_entered(body):
	body.freeze()
	player = body
	next_scene = level_dir+"/"+str((int(String(get_tree().current_scene.name))+1))+".tscn"
	if ResourceLoader.exists(next_scene):
		SceneTransition.change_scene_to(next_scene)
	else:
		SceneTransition.change_scene_to("res://scenes/levels/joudi.tscn")
