extends RigidBody2D

var to_hit = 0

var thrown = false
var parent

const framerate = 60

func _ready():
	$animated_sprite.play("default")
	$hitbox.collision_mask = to_hit
	linear_damp = 0

func _integrate_forces(state):
	if parent and not thrown:
		var here_to_there = parent.global_position - global_position
		# var velocity_gap = here_to_there - state.linear_velocity
		if here_to_there.length() > 4:
			# apply_central_impulse(velocity_gap + )
			state.linear_velocity = here_to_there + parent.linear_velocity

func throw():
	if not thrown:
		thrown = true
		$animated_sprite.play("throw")
		$life_time.start()
		linear_damp = 1
		var direction = (get_global_mouse_position() - global_position).normalized()
		apply_central_impulse(-1 * linear_velocity)
		apply_central_impulse(direction * 300)

func _on_hitbox_body_entered(body):
	if body.has_method("hit_by_lasso"):
		body.hit_by_lasso()
		queue_free()
	else:
		print("woah, %s can't be hit by lassos?" % body.name)

func _on_life_time_timeout():
	queue_free()

# rigid body shape, not hitbox
func _on_lasso_body_entered(_body):
	if thrown:
		queue_free()
