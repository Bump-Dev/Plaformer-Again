extends Camera2D

@export var target:Node2D

func _physics_process(delta):
	global_position = lerp(global_position.round(),target.global_position.round(),0.2)
