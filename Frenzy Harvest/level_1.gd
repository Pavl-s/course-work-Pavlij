extends Node2D

@onready var player = $Player/Player
@onready var results_panel = $ui/ResultsPanel
@onready var gold_label = results_panel.get_node("gold")
@onready var monsters_label = results_panel.get_node("monsters")
@onready var time_label = results_panel.get_node("timeof")
@onready var buttonnext = results_panel.get_node("Buttonnext")

var monsters_killed = 0
const MENU_SCENE_PATH = "res://menu.tscn"

func _ready():
	# Даем время сцене загрузиться перед назначением уровня монстрам
	await get_tree().create_timer(0.1).timeout  

	for mushroom in get_tree().get_nodes_in_group("Mushrooms"):
		mushroom.set_level(self)  # <-- Передаем уровень в монстра
		print("Level assigned to monster:", mushroom)  # Проверка в консоли

	$finisharea.body_entered.connect(_on_finisharea_body_entered)
	results_panel.visible = false
	buttonnext.pressed.connect(_on_buttonnext_pressed)

func _show_results():
	results_panel.visible = true
	gold_label.text = "Gold: %d" % player.gold
	monsters_label.text = "Materials collected: %d" % monsters_killed
	time_label.text = "Time: %.2f секунд" % player.timeof
	get_tree().paused = true

func _on_finisharea_body_entered(body):
	if body.name == "Player":
		_show_results()

func increase_monster_kill_count():
	monsters_killed += 1
	update_monster_label()
	print("Materials collected:", monsters_killed)  # Лог для проверки

func update_monster_label():
	if is_instance_valid(monsters_label):
		monsters_label.text = "Materials collected: %d" % monsters_killed
		print("Updated label:", monsters_killed)  # Проверка
	else:
		print("ERROR: monsters_label is null!")

func _on_buttonnext_pressed() -> void:
	get_viewport().get_tree().paused = false
	get_viewport().get_tree().change_scene_to_file("res://levels.tscn")
