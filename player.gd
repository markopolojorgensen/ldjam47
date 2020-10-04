extends RigidBody2D

const slow_down_scalar = 10

const lasso_scene = preload("res://abilities/lasso.tscn")
var lasso

const orbital_loop_scene = preload("res://abilities/orbital_loop.tscn")

export(int, LAYERS_2D_PHYSICS) var to_hit = 0

func _ready():
	$animated_sprite.play()

func _integrate_forces(state):
	$label.text = str(linear_velocity)
	$TopDownMovement.do_movement(state)
	
	if $TopDownMovement/UserInputDirection.get_intended_direction().length() < 0.1:
		# slow down
		apply_central_impulse(-1 * state.linear_velocity * state.step * slow_down_scalar)

func _process(_delta):
	if lasso:
		$TopDownMovement.max_speed = 200
	else:
		$TopDownMovement.max_speed = 400

func triggers_aggro():
	return true

func _unhandled_input(event):
	if event.is_action_pressed("ability_a"):
		get_tree().set_input_as_handled()
		lasso = lasso_scene.instance()
		lasso.to_hit = to_hit
		lasso.global_position = global_position
		lasso.parent = self
		get_parent().add_child(lasso)
	elif event.is_action_released("ability_a"):
		get_tree().set_input_as_handled()
		if lasso:
			lasso.throw()
			lasso = null
	elif event.is_action_pressed("ability_b"):
		get_tree().set_input_as_handled()
		var inst = orbital_loop_scene.instance()
		inst.global_position = get_global_mouse_position()
		get_parent().add_child(inst)
		 






