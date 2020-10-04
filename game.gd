extends Node

const world_scene = preload("res://world.tscn")
var world

const ending_cutscene = preload("res://ending_cutscene.tscn")

func _ready():
	add_to_group("transition")
	start_new_run()

func switch_to_store():
	world.queue_free()
	$store.show()

func start_new_run():
	$store.hide()
	world = world_scene.instance()
	add_child(world)

func start_ending_cutscene():
	# world.queue_free()
	add_child(ending_cutscene.instance())
	get_tree().paused = true
