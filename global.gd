extends Node

# var loopholes = 0
var loopholes = 100000000

var cross_run_poofs = 15

var active_purchases = []

var lasso_multi = false
var shoe_double_trigger = false
var third_shoe = false

func _ready():
	add_to_group("currency")

func currency_picked_up(type):
	match type:
		"loophole":
			loopholes += 1

func do_ability_purchase(purchase_name):
	active_purchases.append(purchase_name)


