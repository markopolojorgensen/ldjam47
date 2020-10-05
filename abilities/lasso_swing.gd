extends Node2D

var to_hit

const lasso_scene = preload("res://abilities/lasso.tscn")

func _ready():
	$animated_sprite.play("default")

func throw():
	var inst = lasso_scene.instance()
	inst.global_position = global_position
	inst.to_hit = to_hit
	get_parent().get_parent().add_child(inst)
	queue_free()



