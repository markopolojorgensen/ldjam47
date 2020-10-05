extends Node2D

var loophole_count = 0
const loophole_scene = preload("res://loophole.tscn")
var loophole_impulse = Vector2(100, 0)

var hourglass_count = 0
const hourglass_scene = preload("res://hourglass.tscn")


func _ready():
	$animated_sprite.play()
	for _i in range(loophole_count):
		var inst = loophole_scene.instance()
		inst.global_position = global_position
		get_parent().call_deferred("add_child", inst)
		inst.call_deferred("apply_central_impulse", loophole_impulse.rotated(rand_range(-PI, PI)))
	
	for _i in range(hourglass_count):
		var inst = hourglass_scene.instance()
		inst.global_position = global_position
		get_parent().add_child(inst)
		inst.apply_central_impulse(loophole_impulse.rotated(rand_range(-PI, PI)))


func _on_life_timeout():
	queue_free()

