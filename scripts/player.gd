extends CharacterBody2D

var starting_pos:Vector2
var frozen:bool

const DEFAULT_SPEED:float = 1000.0
const DEFAULT_JUMP_VELOCITY:float = -1250.0
const SUPER_JUMP_VELOCITY:float = -2000.0

var speed:float = DEFAULT_SPEED
var jump_velocity:float = DEFAULT_JUMP_VELOCITY
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

const MAX_JUMPS:int = 2
var jumps_left:int = MAX_JUMPS

@onready var sprite:Sprite2D = $Sprite
@onready var ray_cast:RayCast2D = $RayCast2D
@onready var fill_trail:Line2D = $FillTrail
@onready var jumps_left_label:Label = $JumpsLeftLabel
@onready var jumps_left_label_position:Marker2D = sprite.get_node("JumpsLeftLabelPosition")
@onready var jump_particles:GPUParticles2D = $JumpParticles
@onready var jump_buffer_timer:Timer = $JumpBufferTimer

func _ready():
	starting_pos = global_position
	material.set_shader_parameter("invert",false)

func set_jumps_left(value:int):
	jumps_left = value
	jumps_left_label.text = str(jumps_left)

func freeze():
	frozen = true
	velocity = Vector2.ZERO
	sprite.scale = Vector2.ONE

func die():
	freeze()
	material.set_shader_parameter("invert",true)
	modulate = Color.WHITE
	fill_trail.modulate = Color.WHITE
	SceneTransition.change_scene_to(get_tree().current_scene.scene_file_path)

func _physics_process(delta):
	jumps_left_label.global_position = jumps_left_label_position.global_position - jumps_left_label.size/2
	if ray_cast.is_colliding():
		var hit_collider = ray_cast.get_collider()
		if hit_collider is TileMap:
			modulate = hit_collider.modulate
			fill_trail.modulate = hit_collider.modulate
			if !is_on_floor():
				sprite.scale = Vector2(1.5,0.5)
			if hit_collider.name == "Normal":
				set_jumps_left(MAX_JUMPS)
			if hit_collider.name == "SuperJump":
				jump_velocity = SUPER_JUMP_VELOCITY
			else:
				jump_velocity = DEFAULT_JUMP_VELOCITY
			if hit_collider.name == "NoJump":
				set_jumps_left(0)
	
	if !is_on_floor():
		velocity.y += gravity * delta
		sprite.scale = lerp(sprite.scale, Vector2(0.8,1.2),0.2)
	
	if !frozen:
		if Input.is_action_just_pressed("jump"):
			jump_buffer_timer.start()
		if !jump_buffer_timer.is_stopped() && jumps_left:
			velocity.y = jump_velocity
			jump_particles.restart()
			set_jumps_left(jumps_left-1)
			jump_buffer_timer.stop()
		if Input.is_action_just_released("jump") && velocity.y < 0:
			velocity.y /= 2

		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
			sprite.flip_h = sign(direction) == -1
			sprite.scale = lerp(sprite.scale, Vector2(1.1,0.9),0.2)
		else:
			velocity.x = move_toward(velocity.x, 0, speed/2)
			sprite.scale = lerp(sprite.scale, Vector2(1,1),0.2)

	move_and_slide()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
