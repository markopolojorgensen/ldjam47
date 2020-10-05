extends Node2D

export(NodePath) var time_label_path
onready var time_label = get_node(time_label_path)

export(NodePath) var victory_progress_path
onready var victory_progress = get_node(victory_progress_path)

# var time_remaining = 30
var time_remaining = 5

func _ready():
	add_to_group("currency")
	
	print("active purchases:")
	for purchase in global.active_purchases:
		print("  " + purchase)
		match purchase:
			"time_increase_a":
				time_remaining += 5
			"time_increase_b":
				time_remaining += 10
			"pickup_spawn_rate":
				$ability_spawner.increase_spawn_rate()
			"lasso_multi":
				global.lasso_multi = true
			"shoe_double_trigger":
				global.shoe_double_trigger = true
			"third_shoe":
				global.third_shoe = true
			_:
				print("unknown purchase: %s" % purchase)
	

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		get_tree().quit()

func _process(delta):
	time_remaining -= delta
	time_label.text = "%.0f" % time_remaining
	if time_remaining <= 0:
		get_tree().call_group("transition", "switch_to_store")
	
	victory_progress.value = $enemy_spawner.get_victory_progress()

func currency_picked_up(type):
	match type:
		"hourglass":
			time_remaining += 1
		"loophole":
			pass

