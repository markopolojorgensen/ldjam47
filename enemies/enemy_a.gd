extends RigidBody2D

var target

func _ready():
	$animated_sprite.play()

func _integrate_forces(state):
	$TopDownMovement.do_movement(state)
	if not target:
		apply_central_impulse(-1 * state.linear_velocity * state.step * 4)

func _process(delta):
	if target:
		$animated_sprite.speed_scale = 2
	else:
		$animated_sprite.speed_scale = 1

func get_intended_direction():
	if target:
		return target.global_position - global_position
	else:
		return Vector2()

func _on_Aggro_aggro(entity):
	target = entity

func _on_Aggro_aggro_lost(_entity):
	target = null
