extends RigidBody2D

var to_hit = 0

func _ready():
	$hitbox.collision_mask = to_hit
	$animated_sprite.play("throw")
	$life_time.start()
	var direction = (get_global_mouse_position() - global_position).normalized()
	apply_central_impulse(-1 * linear_velocity)
	apply_central_impulse(direction * 300)

func _on_hitbox_body_entered(body):
	if body.has_method("hit_by_lasso"):
		body.hit_by_lasso()
		if not global.lasso_multi:
			queue_free()
	else:
		print("woah, %s can't be hit by lassos?" % body.name)

func _on_life_time_timeout():
	queue_free()

# rigid body shape, not hitbox
func _on_lasso_body_entered(_body):
	if not global.lasso_multi:
		queue_free()
