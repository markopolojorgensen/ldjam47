extends RigidBody2D

export(String, "pushy", "flee", "hem") var ai_type = "pushy"

export(bool) var immune_to_orbital_loops = false
export(bool) var uses_lassos = false

export(int) var min_hourglasses = 1
export(int) var max_hourglasses = 3
export(int) var min_loopholes = 2
export(int) var max_loopholes = 4

var target

var about_to_poof = false
const poof_scene = preload("res://fx/poof.tscn")

const lasso_scene = preload("res://abilities/lasso_swing_enemy.tscn")
var lasso

var boss_poofed = false

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
	
	if uses_lassos and not lasso and $lasso_timer.is_stopped() and target and global_position.distance_to(target.global_position) < 400:
		lasso = lasso_scene.instance()
		add_child(lasso)
		lasso.aimer = self
		$lasso_delay.start()
	elif uses_lassos and lasso and $lasso_delay.is_stopped() and target and global_position.distance_to(target.global_position) < 200:
		lasso.throw()
		$lasso_timer.start()

func get_intended_direction():
	if target:
		if ai_type == "pushy":
			return target.global_position - global_position
		elif ai_type == "flee":
			return global_position - target.global_position
		elif ai_type == "hem":
			var here_to_target = (target.global_position - global_position).normalized()
			var hem_position = target.global_position + (-1 * here_to_target * 150)
			return hem_position - global_position
	else:
		return Vector2()

func hit_by_lasso():
	$stun_timer.wait_time = 3
	$stun_timer.start()
	$lassoed.show()
	if global.lasso_poof and not "boss" in name:
		poof()

func caught_by_orbital_loop():
	if not about_to_poof and not immune_to_orbital_loops:
		about_to_poof = true
		$animated_sprite.play("shrink")
		
		if "boss" in name:
			yield(get_tree().create_timer(1), "timeout")
		else:
			yield(get_tree().create_timer(0.5), "timeout")
		
		poof()

func hit_by_shoe_loop():
	if not about_to_poof and not "boss" in name:
		about_to_poof = true
		call_deferred("poof")

func poof():
	# spawn a poof
	var inst = poof_scene.instance()
	inst.global_position = global_position
	inst.loophole_count = global.rng.randi_range(min_loopholes, max_loopholes)
	inst.hourglass_count = global.rng.randi_range(min_hourglasses, max_hourglasses)
	get_parent().add_child(inst)
	
	get_tree().call_group("enemy", "enemy_poofed")
	
	if "boss" in name and not boss_poofed:
		boss_poofed = true
		yield(get_tree().create_timer(2), "timeout")
		get_tree().call_group("transition", "start_ending_cutscene")
	else:
		queue_free()

func _on_Aggro_aggro(entity):
	target = entity

func _on_Aggro_aggro_lost(_entity):
	target = null

func _on_stun_timer_timeout():
	$lassoed.hide()

func get_lasso_direction():
	if target:
		return (target.global_position - global_position).normalized()
	else:
		return Vector2(0, 1)




