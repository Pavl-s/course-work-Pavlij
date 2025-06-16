extends Area2D

func _on_body_entered(body):
	if body.name =="Player":
		
		var tween= get_tree().create_tween()
		
		tween.tween_callback(queue_free)
		body.gold += 10
