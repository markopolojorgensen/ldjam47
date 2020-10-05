extends MarginContainer

var shaking = false
var noise_x = OpenSimplexNoise.new()
var noise_y = OpenSimplexNoise.new()
var time = 0

var original_position

func _ready():
	noise_y.seed = 1
	original_position = rect_position

func _process(delta):
	if $victory_progress.value >= 100 and not shaking:
		shaking = true
		$label.show()
	
	if shaking:
		time += delta * 1000
		rect_position.x = original_position.x + noise_x.get_noise_1d(time) * 8
		rect_position.y = original_position.y + noise_y.get_noise_1d(time) * 8
		





