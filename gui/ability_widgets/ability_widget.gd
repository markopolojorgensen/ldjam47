extends MarginContainer

export(String) var ability_name

func _ready():
	add_to_group("abilities")

# cooldown: 1 to 100
func update_ability_status(name, cooldown, uses_remaining):
	if name == ability_name:
		$margin_container/texture_progress.value = cooldown
		if name != "lasso":
			if uses_remaining <= 0:
				hide()
			else:
				show()
				$margin_container/v_box_container/uses.text = "x" + str(uses_remaining)





