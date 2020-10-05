extends MarginContainer

func _on_tutorial_pressed():
	get_tree().call_group("transition", "start_tutorial")

func _on_main_game_pressed():
	get_tree().call_group("transition", "start_new_run")
	queue_free()
