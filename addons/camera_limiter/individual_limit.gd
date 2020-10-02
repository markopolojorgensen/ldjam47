extends Node

export(bool) var enabled = true
export(bool) var debug = false
export(String, "limit_left", "limit_right", "limit_top", "limit_bottom") var limit_name
export(int, "negative", "positive") var direction = 1
export(float) var clear_time = 1.0

# must be set by parent
var camera

# limiters currently affecting the camera
# only includes limiters that have a limit for this limit_name (left, top, etc.)
var active_limiters = []

const far_limit = 10000000

func _ready():
	add_to_group("markopolodev_camera")
	print("limiter starting: %s" % limit_name)
	
	$limit_clear_lerper.direction = direction
	$limit_clear_lerper.clear_time = clear_time

func _process(delta):
	if not enabled:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	
	# For each limit we have to pick what to use for the camera center for
	# purposes of figuring out where the "edge of the screen" should be.
	# Basically we're trying to figure out what to use as the destination for our lerp
	# This is not straightforward if the camera is moving, since the "screen center" i.e.
	# what's currently being shown lags behind the camera node's actual position
	# You might think it's either one or the other that we should use in all situations,
	# but it's not.
	# In the case where the camera is moving in the direction of the limit,
	# the goal of the limit should be based on the camera's position, not the screen center.
	# That way, the lerped limit is moving beyond the bounds of the actual screen
	# However, in the case where the camera is moving in the opposite direction of the limit,
	# the goal of the limit should be based on the screen center, I think.
	# The conclusion is that we should treat the screen as though it's bigger than it is;
	# we should treat the screen as though the center is actually a bounding box formed by the
	# screen center and camera position
	# use whichever one of the positions is closer to the limit we're dealing with
	# ALSO for some reason camera.global_position and camera.get_camera_position() are
	# not always the same thing
	var cam_pos = camera.global_position
	var cam_center = camera.get_camera_screen_center()
	
	var limit_active = not active_limiters.empty()
	
	var signed_far_limit
	if limit_active:
		signed_far_limit = active_limiters.front().get_limits()[limit_name]
	else:
		if direction >= 1:
			signed_far_limit = far_limit
		else:
			signed_far_limit = -far_limit
	
	# this is not actually the final limit
	# rather it's the final value of the lerp
	# as soon as the lerp is finished we cut to the far limit,
	# which is the actual final limit
	var final
	match limit_name:
		"limit_right":
			final = max(cam_pos.x, cam_center.x) + (viewport_size.x / 2.0)
		"limit_left":
			final = min(cam_pos.x, cam_center.x) - (viewport_size.x / 2.0)
		"limit_top":
			final = min(cam_pos.y, cam_center.y) - (viewport_size.y / 2.0)
		"limit_bottom":
			final = max(cam_pos.y, cam_center.y) + (viewport_size.y / 2.0)
	
	# pretty inefficient to be doing this every frame
	# TODO: switch to signal based stuff? we only need _process for when lerper.clearing
	if limit_active and $limit_clear_lerper.clearing:
		$limit_clear_lerper.reset()
		# don't set actual camera limit, it might be getting tweened right now
	elif not limit_active and $limit_clear_lerper.clearing:
		# print(camera.get_camera_position().y + (get_viewport().get_visible_rect().size.y / 2.0))
		var current_limit = $limit_clear_lerper.fancy_lerp(delta, final)
		if current_limit == final:
			# we're done
			camera.set(limit_name, signed_far_limit)
		else:
			# lerping continues
			# print("%.0f" % current_limit)
			camera.set(limit_name, current_limit)
	elif not limit_active and not $limit_clear_lerper.clearing:
		camera.set(limit_name, signed_far_limit)

func set_limits(limiter):
	if not enabled:
		return
	
	# only care if limiter has the relevant limit
	if not limiter.get_limits().has(limit_name):
		return
	
	# if this limiter is already active, move it to the top of the stack
	# otherwise, just add it to the top of the stack
	# translates to:
	# remove the limiter if it's present
	# then add the limiter to the top of the stack
	#
	# we only care about this for when it comes time to clear limits
	# we might clear the current top of the stack (where there's another behind it)
	# in which case we don't want to clear to the full limit
	# we want to clear to the old limit that's still active
	if active_limiters.has(limiter):
		active_limiters.erase(limiter)
	active_limiters.push_front(limiter)
	
	# limiter_limit is the limit value
	var limiter_limit = limiter.get_limits()[limit_name]
	
	# find viewport edge
	var viewport_edge
	var camera_rect = Rect2()
	camera_rect.size = get_viewport().get_visible_rect().size
	# top left corner
	camera_rect.position = camera.get_camera_screen_center() - (camera_rect.size / 2.0)
	match limit_name:
		"limit_top":
			viewport_edge = camera_rect.position.y
		"limit_bottom":
			viewport_edge = camera_rect.position.y + camera_rect.size.y
		"limit_left":
			viewport_edge = camera_rect.position.x
		"limit_right":
			viewport_edge = camera_rect.position.x + camera_rect.size.x
	
	# is initial viewport edge or limiter limit?
	var initial
	if direction >= 1:
		# far
		initial = max(viewport_edge, limiter_limit)
	else:
		# near
		initial = min(viewport_edge, limiter_limit)
	
	
	camera.set(limit_name, initial)
	
	var final = limiter_limit
	
	if debug:
		print("setting %s: %s -> %s" % [limit_name, initial, final])
	
	$tween.stop_all()
	$tween.interpolate_property(camera, limit_name, initial, final, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.start()

func clear_limits(limiter):
	if not enabled:
		return
	
	# don't care about limits that aren't this one
	if not limiter.get_limits().has(limit_name):
		return
	
	# if the limiter being cleared is the top limiter in the stack,
	# then the camera's current limit needs to change.
	#   if there are no other active limiters, clear it
	#   otherwise, go back to the next previously active limiter's limit
	#
	# if the limiter being cleared wasn't the top limiter in the stack,
	# then we still remove it but don't change the camera's current limit
	
	# figure out if we need to update camera first
	var update_camera = (active_limiters.front() == limiter)
	
	# remove the limiter
	active_limiters.erase(limiter)
	
	if update_camera:
		if active_limiters.empty():
			# no active limiters, clear it
			if debug:
				print("clearing %s" % limit_name)
			$limit_clear_lerper.start_clear(camera.get(limit_name))
		else:
			# use next highest limiter on the stack
			if debug:
				print("falling back %s to previous limiter" % limit_name)
			set_limits(active_limiters.front())
	else:
		if debug:
			print("removed limiter, not top of stack, no action")


