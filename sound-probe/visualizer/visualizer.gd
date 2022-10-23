extends Node2D

export var size = Vector2() setget set_size

var DEFINITION = 200
var MIN_FREQUENCY = 20
var MAX_FREQUENCY = 20000
var MAX_DB = 0
var MIN_DB = -180
var ACCELERATION = 4
var BAR_WIDTH = 8

var spectrum
var frequency_interval
var width_interval
var histogram = []

func _ready():
	var bus_id = AudioServer.get_bus_index("space_sound")
	spectrum = AudioServer.get_bus_effect_instance(bus_id, 0)
	
	frequency_interval = (MAX_FREQUENCY - MIN_FREQUENCY) / DEFINITION
	set_size(size)
	
	for _i in range(DEFINITION):
		histogram.append(0)

func _process(delta):
	for i in range(DEFINITION):
		var mag = spectrum.get_magnitude_for_frequency_range(frequency_interval * i, frequency_interval * (i + 1))
		mag = linear2db(mag.length())
		mag = (mag - MIN_DB) / (MAX_DB - MIN_DB)
		mag = clamp(mag, 0, 1)
		mag = lerp(histogram[i], mag, ACCELERATION * delta)
		histogram[i] = mag
	
	update()

func _draw():
	for i in range(histogram.size()):
		var begin = Vector2((BAR_WIDTH / 2.0) + width_interval * i, 0)
		var end = begin + Vector2(0, -histogram[i] * size.y)
		draw_line(begin, end, Color(1, 1, 1, histogram[i] * 4), BAR_WIDTH, false)

func set_size(new_size):
	size = new_size
	width_interval = new_size.x / DEFINITION
