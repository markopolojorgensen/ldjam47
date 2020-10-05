extends Node2D

const total_poof_count = 100
var poof_count = 0
var desired_enemy_count = 10

const enemy_a_scene = preload("res://enemies/enemy_a.tscn")
const enemy_b_scene = preload("res://enemies/enemy_b.tscn")

var mixes = [
	{
		"poofs": 5,
		"desired_enemy_count": 10,
		"mix": {
			"a": 1
			},
	},
	{
		"poofs": 5,
		"desired_enemy_count": 15,
		"mix": {
			"a": 0.75,
			"b": 0.25,
			},
	},
	{
		"poofs": 5,
		"desired_enemy_count": 20,
		"mix": {
			"a": 0.1,
			"b": 0.9,
			},
	},
	{
		"poofs": 5,
		"desired_enemy_count": 25,
		"mix": {
			"a": 0.5,
			"b": 0.5,
			},
	},
]


func _ready():
	add_to_group("enemy")

func _process(_delta):
	if $enemies.get_child_count() < desired_enemy_count:
		# print("picking enemy type")
		var index = 0
		var cumulative_poofs = mixes[0]["poofs"]
		# print("  total poofs: %d" % global.cross_run_poofs)
		while cumulative_poofs < global.cross_run_poofs and index < (mixes.size()-1):
			# print("  cumulative poofs: %d" % cumulative_poofs)
			index += 1
			cumulative_poofs += mixes[index]["poofs"]
		
		# print("  index -> %d" % index)
		var mix = mixes[index]["mix"]
		desired_enemy_count = mixes[index]["desired_enemy_count"]
		while $enemies.get_child_count() < desired_enemy_count:
			var rng = randf()
			# print("  rng: %f" % rng)
			index = 0
			var cumulative_rng = 0
			var final_key
			for key in mix.keys():
				cumulative_rng += mix[key]
				if cumulative_rng > rng:
					final_key = key
					break
			
			var inst
			# print("    final key: %s" % final_key)
			match final_key:
				"a":
					inst = enemy_a_scene.instance()
				"b":
					inst = enemy_b_scene.instance()
			
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
	global.cross_run_poofs += 1
	if poof_count >= total_poof_count:
		get_tree().call_group("transition", "start_ending_cutscene")

func get_victory_progress():
	return poof_count / total_poof_count * 100.0

