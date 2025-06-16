extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var speed = 200
var alive = true
var level = null  # Уровень передается сюда

@onready var anim = $AnimatedSprite2D
@onready var player = $"../../Player/Player"

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if alive:
		var direction = (player.position - position).normalized()

		if chase:
			velocity.x = direction.x * speed
			anim.play("Run")
		else:
			velocity.x = 0
			anim.play("Idle")

		anim.flip_h = direction.x < 0

	move_and_slide()

# Игрок входит в зону видимости — монстр начинает преследование
func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true

# Игрок наступает сверху — монстр погибает
func _on_death_body_entered(body):
	if body.name == "Player":
		body.velocity.y -= 200  # Отскок игрока
		death()

# Монстр атакует игрока, если тот не напал первым
func _on_death_2_body_entered(body):
	if body.name == "Player" and alive:
		body.heals -= 25
		death()

# Игрок выходит из зоны видимости — монстр перестает преследовать
func _on_detector_body_exited(body):
	if body.name == "Player":
		chase = false

# Логика смерти
func death(): 
	alive = false
	anim.play("Death")

	if level and is_instance_valid(level):
		level.increase_monster_kill_count()
		print("Monster killed! Updated count:", level.monsters_killed)  # Проверка
	else:
		print("ERROR: level is null!")

	await anim.animation_finished
	queue_free()

# Передача уровня монстру
func set_level(level_ref):
	level = level_ref
	if level:
		print("Monster received level:", level)  # Проверка
	else:
		print("ERROR: Monster did not receive level!")
