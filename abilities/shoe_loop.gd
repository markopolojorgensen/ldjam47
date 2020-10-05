extends Node2D

onready var shoe_loop_scene = load("res://abilities/shoe_loop.tscn")
var is_third_shoe = false

var set = false

var trigger = false

func _ready():
	add_to_group("shoes")
	$shoe_a.frame = randi() % 6
	$shoe_b.frame = randi() % 6

func _process(_delta):
	if not set:
		var here_to_mouse = get_global_mouse_position() - global_position
		rotation = stepify(here_to_mouse.angle(), PI/2)
	
	$shoe_a.global_rotation = 0
	$shoe_b.global_rotation = 0

func _unhandled_input(event):
	if not set and event.is_action_released("ability_b"):
		get_tree().set_input_as_handled()
		set = true
		$loop.play()
		if global.third_shoe and not is_third_shoe:
			var inst = shoe_loop_scene.instance()
			inst.global_position = $shoe_b.global_position
			inst.is_third_shoe = true
			get_parent().add_child(inst)

func _on_hitbox_body_entered(body):
	if set:
		if body.has_method("hit_by_shoe_loop"):
			body.hit_by_shoe_loop()
			if $trap_timer.is_stopped():
				$trap_timer.start()
				yield($trap_timer, "timeout")
				if global.shoe_double_trigger and not trigger:
					trigger = true
				else:
					queue_free()

		else:
			print("%s is immune to shoe loops?!" % body.name)
