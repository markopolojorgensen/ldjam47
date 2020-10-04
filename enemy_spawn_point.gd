extends Position2D

func is_available():
	return not $visibility_notifier_2d.is_on_screen()


