extends CanvasLayer

func show():
	$margin_container.show()
	$bg.show()
	$wallet_overlay.show()

func hide():
	$margin_container.hide()
	$bg.hide()
	$wallet_overlay.hide()

func _on_new_run_button_pressed():
	get_tree().call_group("transition", "start_new_run")
