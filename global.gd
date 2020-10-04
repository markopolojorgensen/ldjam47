extends Node

var loopholes = 10

var active_purchases = []

func _ready():
	add_to_group("currency")

func currency_picked_up(type):
	match type:
		"loophole":
			loopholes += 1

func do_ability_purchase(purchase_name):
	active_purchases.append(purchase_name)


