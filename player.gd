extends RigidBody2D

const slow_down_scalar = 10

const lasso_scene = preload("res://abilities/lasso_swing.tscn")
var lasso

const orbital_loop_scene = preload("res://abilities/orbital_loop.tscn")

var secondary_ability

export(int, LAYERS_2D_PHYSICS) var to_hit = 0

func _ready():
	add_to_group("currency")
	
	$animated_sprite.play()
	$eyes.play()

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
	
	if linear_velocity.x > 10:
		$eyes.flip_h = false
	elif linear_velocity.x < -10:
		$eyes.flip_h = true
	
	if linear_velocity.y > 100:
		$eyes.offset.y = 1
	elif linear_velocity.y < -100:
		$eyes.offset.y = -1
	else:
		$eyes.offset.y = 0

func triggers_aggro():
	return true

func _unhandled_input(event):
	if event.is_action_pressed("ability_a") and $ability_managers/lasso_ability_manager.is_stopped():
		get_tree().set_input_as_handled()
		$ability_managers/lasso_ability_manager.start()
		lasso = lasso_scene.instance()
		lasso.to_hit = to_hit
		add_child(lasso)
	elif event.is_action_released("ability_a"):
		get_tree().set_input_as_handled()
		if lasso:
			lasso.throw()
			lasso = null
	elif event.is_action_pressed("ability_b") and secondary_ability and secondary_ability.is_stopped() and secondary_ability.uses > 0:
		if "shoelace" in secondary_ability.name:
			for shoe in get_tree().get_nodes_in_group("shoes"):
				if not shoe.set:
					return
		
		get_tree().set_input_as_handled()
		secondary_ability.start()
		secondary_ability.uses -= 1
		var inst = secondary_ability.ability_scene.instance()
		inst.global_position = get_global_mouse_position()
		get_parent().add_child(inst)

func caught_by_orbital_loop():
	$eyes.play("woah")
	yield(get_tree().create_timer(1.5), "timeout")
	$eyes.play("default")

func currency_picked_up(name):
	for ability_manager in $ability_managers.get_children():
		if ability_manager.ability_name == name:
			secondary_ability = ability_manager
		elif name == "orbital_loop" or name == "shoelace_loop":
			ability_manager.uses = 0


