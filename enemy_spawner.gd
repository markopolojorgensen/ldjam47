extends Node2D

var poof_count = 0
var desired_enemy_count = 5

const enemy_a_scene = preload("res://enemies/enemy_a.tscn")

func _ready():
	add_to_group("enemy")

func _process(_delta):
	while $enemies.get_child_count() < desired_enemy_count:
		var inst = enemy_a_scene.instance()
		inst.global_position = get_random_spawn()
		$enemies.add_child(inst)

func reset():
	poof_count = 0
	for enemy in $enemies.get_children():
		enemy.queue_free()

func get_random_spawn():
	var index = randi() % $spawns.get_child_count()
	while not $spawns.get_child(index).is_available():
		index = randi() % $spawns.get_child_count()
	
	return $spawns.get_child(index).global_position

func enemy_poofed():
	poof_count += 1

