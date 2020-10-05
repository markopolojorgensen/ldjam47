extends Node2D

var to_hit = 0

var pull_scalar = 5000

var fading = false

func _ready():
	$animated_sprite.play()
	
	$tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()
	# $gravity_well.collision_mask = to_hit

func _physics_process(delta):
	for body in $gravity_well.get_overlapping_bodies():
		if body.has_method("apply_central_impulse"):
			var pull : Vector2 = global_position - body.global_position
			# var inverse_magnitude = 128 - pull.clamped(128).length()
			# body.apply_central_impulse(pull.normalized() * pull_scalar * inverse_magnitude * delta)
			body.apply_central_impulse(pull.normalized() * pull_scalar * delta)

func _process(_delta):
	if not fading and $life_time.time_left < 1:
		fading = true
		$tween.stop_all()
		$tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$tween.start()

func _on_life_time_timeout():
	queue_free()

func _on_gravity_well_body_entered(body):
	if body.has_method("caught_by_orbital_loop"):
		body.caught_by_orbital_loop()
	else:
		print("%s can't be orbital looped?" % body.name)






