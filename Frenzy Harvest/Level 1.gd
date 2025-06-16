extends Button

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://level.tscn")
