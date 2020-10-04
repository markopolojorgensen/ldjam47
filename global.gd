extends Node

var loopholes = 0


func _ready():
	add_to_group("currency")

func currency_picked_up(type):
	match type:
		"loophole":
			loopholes += 1


