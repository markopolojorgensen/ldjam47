extends Node

var clearing = false
var clearing_weight = 0
var clear_initial_limit = 0
var clear_time_elapsed = 0
var most_intense_so_far
export(int, "negative", "positive") var direction = 1
export(float) var clear_time = 1.0

# final -> camera position +/- 1/2 screen dimension
#   i.e. the destination limit
func fancy_lerp(delta, final):
	if clearing:
		clear_time_elapsed += delta
		if clear_time_elapsed > clear_time:
			# yay, finished the tween without interruption
			reset()
			return final
		
		clearing_weight = clear_time_elapsed / float(clear_time)
		
		# quadratic
		var clearing_in_weight = pow(clearing_weight, 2)
		
		var clearing_out_weight
		# quadratic
		# clearing_out_weight = -pow(clearing_weight - 1, 2) + 1
		# cubic
		# clearing_out_weight = pow(clearing_weight - 1, 3) + 1
		# trig
		clearing_out_weight = sin(5 * clearing_weight / PI)
		
		# bezier style meta-interpolation
		clearing_weight = lerp(clearing_in_weight, clearing_out_weight, clearing_weight)
		
		var result = lerp(clear_initial_limit, final, clearing_weight)
		
		# if the player keeps moving after exiting the zone, the lerping limit should never go
		# back in the direciton it came from
		# print("dir: %d | most_intense: %.0f | result: %.0f | final: %.0f" % [direction, most_intense_so_far, result, final])
		if direction > 0 and result > most_intense_so_far:
			most_intense_so_far = result
		elif direction <= 0 and result < most_intense_so_far:
			most_intense_so_far = result
		else:
			# result is not in the direction we want, don't use it
			result = most_intense_so_far
		
		return result

func start_clear(initial):
	# print("start lerp clear")
	clear_initial_limit = initial
	most_intense_so_far = initial
	clearing = true

func reset():
	# print("reset lerp clear")
	clearing = false
	clear_time_elapsed = 0
	clearing_weight = 0
