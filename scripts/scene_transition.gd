extends CanvasLayer

@onready var color_rect := $ColorRect
@onready var animation_player := $AnimationPlayer

func change_scene_to(path:String,duration:float=0.2,color:Color=Color.BLACK,delay:float=0):
	color_rect.color = color
	
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
