extends RigidBody2D

const slow_down_scalar = 10

func _ready():
	$animated_sprite.play()

func _integrate_forces(state):
	$TopDownMovement.do_movement(state)
	
	if $TopDownMovement/UserInputDirection.get_intended_direction().length() < 0.1:
		# slow down
		apply_central_impulse(-1 * state.linear_velocity * state.step * slow_down_scalar)

func triggers_aggro():
	return true




