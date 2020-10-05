extends Button

func _on_play_button_pressed():
	get_tree().call_group("transition", "start_new_run")
