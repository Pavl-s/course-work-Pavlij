extends CharacterBody2D

enum {
	IDLE,
	MOVE,
	ATTACK
}

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var heals = 75
var gold = 0
var state = MOVE
var run_speed = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var monsters : int  = 0
var timeof : float = 0.0

func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			await attack_state() 

	if not is_on_floor():
		velocity.y += gravity * delta

	if velocity.y > 0:
		animPlayer.play("fall")

	if heals <= 0:
		heals = 0 
		animPlayer.play("death")
		await animPlayer.animation_finished
		get_tree().change_scene_to_file("res://menu.tscn")
		queue_free()
	move_and_slide()
		
func move_state():
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0:
			if run_speed == 1 :
				animPlayer.play("walk")
			else:
				animPlayer.play("run")
	else:
		velocity.x = 0
		if is_on_floor():
			animPlayer.play("idle")
			
	if direction==-1:
		anim.flip_h=true
	elif direction ==1:
		anim.flip_h=false
	
	if Input.is_action_just_pressed("jump") :
		velocity.y = JUMP_VELOCITY
		animPlayer.play("jump")
	
	if Input.is_action_pressed("run"):
		run_speed = 2
	else:
		run_speed = 1
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func attack_state():
	velocity.x = 0
	animPlayer.play("attack")
	await animPlayer.animation_finished
	state = MOVE

func _process(delta):
	timeof += delta
