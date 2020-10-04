tool
extends MarginContainer

export(String) var purchase_name = "???"
export(int) var cost = 100 setget set_cost
export(String, MULTILINE) var description = "does a thing" setget set_description

func _ready():
	set_description(description)
	set_cost(cost)

func _process(_delta):
	if not Engine.editor_hint:
		if global.loopholes < cost:
			$margin_container/v_box_container/h_box_container/buy_button.disabled = true
		else:
			$margin_container/v_box_container/h_box_container/buy_button.disabled = false

func set_description(new_desc):
	description = new_desc
	if has_node("margin_container/v_box_container/description"):
		$margin_container/v_box_container/description.text = new_desc

func set_cost(new_cost):
	cost = new_cost
	if has_node("margin_container/v_box_container/h_box_container/cost"):
		$margin_container/v_box_container/h_box_container/cost.text = str(cost)

func _on_buy_button_pressed():
	# todo check wallet
	if global.loopholes >= cost:
		global.loopholes -= cost
		
		global.do_ability_purchase(purchase_name)
	
		$margin_container/v_box_container/h_box_container/cost.hide()
		$margin_container/v_box_container/h_box_container/texture_rect.hide()
		$margin_container/v_box_container/h_box_container/buy_button.hide()
	
		$margin_container/v_box_container/h_box_container/bought.show()






