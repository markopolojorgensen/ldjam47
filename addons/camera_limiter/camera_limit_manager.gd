extends Node

# you have to tell this node where the actual camera object is.
# bonus points if this camera limiter is the direct child of your camera object, composition ftw.
export(NodePath) var camera_path
onready var camera : Camera2D = get_node(camera_path)

export(bool) var enabled = true

# print debug info
export(bool) var debug = false

var far_limit = 10000000

var active_limits = {}

# I tried using only a single tween object, but it didn't work. Not sure why.
func _ready():
	# add_to_group("markopolodev_camera")
	$individual_limit_left.camera   = camera
	$individual_limit_right.camera  = camera
	$individual_limit_top.camera    = camera
	$individual_limit_bottom.camera = camera
	
	for child in get_children():
		if "camera" in child:
			child.camera = camera
		if "debug" in child:
			child.debug = debug
	

func _process(delta):
	if not enabled:
		return
	
#	do_lerp_clearing("limit_right",  $lerp_right,  delta,  far_limit, max(cam_pos.x, cam_center.x) + (viewport_size.x / 2.0))
#	do_lerp_clearing("limit_left",   $lerp_left,   delta, -far_limit, min(cam_pos.x, cam_center.x) - (viewport_size.x / 2.0))
#	do_lerp_clearing("limit_top",    $lerp_top,    delta, -far_limit, min(cam_pos.y, cam_center.y) - (viewport_size.y / 2.0))
#	do_lerp_clearing("limit_bottom", $lerp_bottom, delta,  far_limit, max(cam_pos.y, cam_center.y) + (viewport_size.y / 2.0))
	
	$debug/VBoxContainer/left.text   = "%.0f" % camera.limit_left
	$debug/VBoxContainer/right.text  = "%.0f" % camera.limit_right
	$debug/VBoxContainer/top.text    = "%.0f" % camera.limit_top
	$debug/VBoxContainer/bottom.text = "%.0f" % camera.limit_bottom

## pretty inefficient to be doing this every frame
## TODO: switch to signal based stuff? we only need _process for when lerper.clearing
#func do_lerp_clearing(limit, lerper, delta, max_limit, final):
#		var limit_active = active_limits.has(limit) and active_limits[limit]
#		if limit_active and lerper.clearing:
#			lerper.reset()
#			# don't set actual camera limit, it might be getting tweened right now
#		elif lerper.clearing:
#			# print(camera.get_camera_position().y + (get_viewport().get_visible_rect().size.y / 2.0))
#			var current_limit = lerper.fancy_lerp(delta, final)
#			if current_limit == final:
#				# we're done
#				camera.set(limit, max_limit)
#			else:
#				# lerping continues
#				# print("%.0f" % current_limit)
#				camera.set(limit, current_limit)
#		elif not limit_active and not lerper.clearing:
#			camera.set(limit, max_limit)

#func set_limits(limiter):
#	if not enabled:
#		return
#
#	var camera_rect = Rect2()
#	camera_rect.size = get_viewport().get_visible_rect().size
#	# top left corner
#	camera_rect.position = camera.get_camera_screen_center() - (camera_rect.size / 2.0)
#
#	tween_limit(limiter, "limit_top",    camera_rect.position.y,                      $tween_top)
#	tween_limit(limiter, "limit_bottom", camera_rect.position.y + camera_rect.size.y, $tween_bottom)
#	tween_limit(limiter, "limit_left",   camera_rect.position.x,                      $tween_left)
#	tween_limit(limiter, "limit_right",  camera_rect.position.x + camera_rect.size.x, $tween_right)

#func clear_limits(limiter):
#	clear_limit(limiter, "limit_top", $tween_top)
#	clear_limit(limiter, "limit_bottom", $tween_bottom)
#	clear_limit(limiter, "limit_right", $tween_right)
#	clear_limit(limiter, "limit_left", $tween_left)

#func tween_limit(limiter, limit, viewport_edge, tween):
#	var limits = limiter.get_limits()
#	if limits.has(limit):
#		var initial
#		if not active_limits.has(limit) or not active_limits[limit]:
#			if limit == "limit_top" or limit == "limit_left":
#				# near
#				initial = min(viewport_edge, limits[limit])
#				camera.set(limit, initial)
#			else:
#				# far
#				initial = max(viewport_edge, limits[limit])
#				camera.set(limit, initial)
#
#		if debug:
#			print("setting %s: %s" % [limit, initial])
#		active_limits[limit] = limiter
#
#		var final = limits[limit]
#		tween.stop_all()
#		tween.interpolate_property(camera, limit, initial, final, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
#		tween.start()

#func clear_limit(limiter, limit, tween):
#	if not enabled:
#		return
#
#	var limits = limiter.get_limits()
#	# only clear limit if it was set by the limiter we just left, otherwise leave it be
#	if limits.has(limit) and active_limits[limit] == limiter and abs(camera.get(limit)) != far_limit:
#		if debug:
#			print("clearing %s" % limit)
#		active_limits[limit] = null
#		if limit == "limit_top":
#			$lerp_top.start_clear(camera.limit_top)
#		elif limit == "limit_bottom":
#			$lerp_bottom.start_clear(camera.limit_bottom)
#		elif limit == "limit_left":
#			$lerp_left.start_clear(camera.limit_left)
#		elif limit == "limit_right":
#			$lerp_right.start_clear(camera.limit_right)


