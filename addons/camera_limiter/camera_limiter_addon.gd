tool
extends EditorPlugin

# This plugin adds one type, but it's also got a scene.
# use the "add child node" menu to get camera_limit_area nodes
# use the "instance a scene file as a node" menu to get the camera_limiter

func _enter_tree():
	#add_custom_type("CameraLimiter", "Node", preload("focus_limiter.gd"), preload("node.svg"))
	add_custom_type("CameraLimitArea", "Area2D", preload("camera_limiting_area.gd"), preload("area_2d.svg"))
	pass

func _exit_tree():
	#remove_custom_type("CameraLimiter")
	remove_custom_type("CameraLimitArea")
	pass

