extends RigidBody2D

export(String, "pushy", "flee") var ai_type = "pushy"

var target

var about_to_poof = false
const poof_scene = preload("res://fx/poof.tscn")

func _ready():
	$animated_sprite.play()

func _integrate_forces(state):
	if $stun_timer.is_stopped():
		$TopDownMovement.do_movement(state)
	if not target or not $stun_timer.is_stopped():
		apply_central_impulse(-1 * state.linear_velocity * state.step * 4)

func _process(_delta):
	if target:
		$animated_sprite.speed_scale = 2
	else:
		$animated_sprite.speed_scale = 1

func get_intended_direction():
	if target:
		if ai_type == "pushy":
			return target.global_position - global_position
		elif ai_type == "flee":
			return global_position - target.global_position
	else:
		return Vector2()

func hit_by_lasso():
	$stun_timer.wait_time = 3
	$stun_timer.start()
	$lassoed.show()

func caught_by_orbital_loop():
	if not about_to_poof:
		about_to_poof = true
		$animated_sprite.play("shrink")
		
		yield(get_tree().create_timer(0.5), "timeout")
		
		poof()

func hit_by_shoe_loop():
	if not about_to_poof:
		about_to_poof = true
		call_deferred("poof")

func poof():
	# spawn a poof
	var inst = poof_scene.instance()
	inst.global_position = global_position
	inst.loophole_count = (randi() % 3) + 1
	inst.hourglass_count = (randi() % 3) + 1
	get_parent().add_child(inst)
	
	get_tree().call_group("enemy", "enemy_poofed")
	
	queue_free()

func _on_Aggro_aggro(entity):
	target = entity

func _on_Aggro_aggro_lost(_entity):
	target = null

func _on_stun_timer_timeout():
	$lassoed.hide()

