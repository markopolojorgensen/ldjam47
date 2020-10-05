extends Node2D

# var to_hit

export(bool) var is_enemy_lasso = false

var aimer

const lasso_scene = preload("res://abilities/lasso.tscn")
const enemy_lasso_scene = preload("res://abilities/enemy_lasso.tscn")

func _ready():
	$animated_sprite.play("default")

func throw():
	var inst
	if is_enemy_lasso:
		inst = enemy_lasso_scene.instance()
	else:
		inst = lasso_scene.instance()
	inst.global_position = global_position
	# inst.to_hit = to_hit
	inst.aimer = aimer
	get_parent().get_parent().add_child(inst)
	queue_free()



