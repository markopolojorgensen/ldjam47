extends Node

const world_scene = preload("res://world.tscn")
var world

const tutorial_scene = preload("res://tutorial.tscn")
var tutorial

const main_menu_scene = preload("res://main_menu.tscn")
var main_menu

const ending_cutscene = preload("res://ending_cutscene.tscn")

func _ready():
	add_to_group("transition")
	start_main_menu()

func switch_to_store():
	if world:
		world.queue_free()
	if main_menu:
		main_menu.queue_free()
	
	$store.show()
	$music_manager.fade_to_store()

func start_new_run():
	$store.hide()
	if main_menu:
		main_menu.queue_free()
	if tutorial:
		tutorial.queue_free()
	
	world = world_scene.instance()
	add_child(world)
	$music_manager.fade_to_game()

func start_main_menu():
	$store.hide()
	main_menu = main_menu_scene.instance()
	add_child(main_menu)

func start_tutorial():
	$store.hide()
	if world:
		world.queue_free()
	
	if main_menu:
		main_menu.queue_free()
	
	tutorial = tutorial_scene.instance()
	add_child(tutorial)

func start_ending_cutscene():
	$store.hide()
	# world.queue_free()
	add_child(ending_cutscene.instance())
	get_tree().paused = true


