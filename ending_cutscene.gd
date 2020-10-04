extends CanvasLayer

export(bool) var shake = false
var noise_x = OpenSimplexNoise.new()
var noise_y = OpenSimplexNoise.new()
var time = 0

var original_ring_position

func _ready():
	noise_y.seed = 1
	original_ring_position = $node_2d/coil_container.position

func _process(delta):
	if shake:
		time += delta * 1000
		$node_2d/coil_container.position.x = original_ring_position.x + noise_x.get_noise_1d(time) * 8
		$node_2d/coil_container.position.y = original_ring_position.y + noise_y.get_noise_1d(time) * 8
		



