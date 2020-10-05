extends Node2D

const orbital_loop_pickup_scene = preload("res://abilities/orbital_loop_pickup.tscn")
const shoelace_loop_pickup_scene = preload("res://abilities/shoe_loop_pickup.tscn")

func _ready():
	_on_ability_spawn_interval_timeout()

func increase_spawn_rate():
	$ability_spawn_interval.wait_time *= 0.75

func get_random_spawn():
	var index = randi() % $spawns.get_child_count()
	while $spawns.get_child(index).is_on_screen():
		index = randi() % $spawns.get_child_count()
	
	return $spawns.get_child(index).global_position

func _on_ability_spawn_interval_timeout():
	print("spawned new orbital loop")
	var inst
	var rng = randf()
	if rng < 0.1:
		inst = orbital_loop_pickup_scene.instance()
	else:
		inst = shoelace_loop_pickup_scene.instance()
	
	inst.global_position = get_random_spawn()
	$abilities.add_child(inst)
