extends Timer

export(String) var ability_name = "???"
export(int) var uses_per_pickup = 5
var uses = 0

export(PackedScene) var ability_scene

func _ready():
	add_to_group("currency")

func _process(_delta):
	var cooldown_percent = (1.0 - (time_left / wait_time)) * 100
	get_tree().call_group("abilities", "update_ability_status", ability_name, cooldown_percent, uses)

func currency_picked_up(name):
	if name == ability_name:
		uses += uses_per_pickup

