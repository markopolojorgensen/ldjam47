extends RigidBody2D

var target
const pickup_scalar = 5000

export(String) var resource_type = "???"

func _ready():
	$animated_sprite.frame = randi() % $animated_sprite.frames.get_frame_count("default")
	$animated_sprite.play()

func _physics_process(delta):
	if target:
		var here_to_there = target.global_position - global_position
		apply_central_impulse(here_to_there.normalized() * delta * pickup_scalar)

func _on_pickup_detector_body_entered(body):
	if not target:
		target = body
		collision_mask = 0
		get_tree().call_group("currency", "currency_picked_up", resource_type)
		$fade.start()
		$tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$tween.start()

func _on_fade_timeout():
	queue_free()
