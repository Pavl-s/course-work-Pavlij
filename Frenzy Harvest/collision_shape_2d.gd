extends CollisionShape2D

@export var next_scene_path: String

@onready var panel = get_node("/root/Level/CanvasLayer2/Panel")

func _on_body_entered(body):
	if body.name == "Player":
		var time_label = panel.get_node("Time")
		var gold_label = panel.get_node("Gold")
		time_label.text = "Час: " + round(body.time_passed) + " сек"
		gold_label.text = "Монет: " + str(body.gold)
		body.finish_level()
