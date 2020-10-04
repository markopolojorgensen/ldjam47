extends Node2D

export(NodePath) var time_label_path
onready var time_label = get_node(time_label_path)

export(NodePath) var wallet_label_path
onready var wallet_label = get_node(wallet_label_path)

var time_remaining = 60

func _ready():
	add_to_group("currency")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		get_tree().quit()

func _process(delta):
	time_remaining -= delta
	time_label.text = "%.0f" % time_remaining
	
	wallet_label.text = str(global.loopholes)

func currency_picked_up(type):
	match type:
		"hourglass":
			time_remaining += 5
		"loophole":
			pass

