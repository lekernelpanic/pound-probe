extends Node2D
# Analyze an audio bus and draw the visualizer.


const AUDIO_BUS_NAME = "space_sound"
const DEFINITION = 200
const MIN_FREQUENCY = 20
const MAX_FREQUENCY = 20_000
const MAX_DB = 0
const MIN_DB = -180
const ACCELERATION = 4
const BAR_WIDTH = 8
const BAR_TRANSPARENCY_MULTIPLIER = 4

export var size = Vector2() setget set_size

var _spectrum
var _frequency_interval
var _width_interval
var _histogram


func _init():
	_histogram = []
	for _i in range(DEFINITION):
		_histogram.append(0)
	
	_frequency_interval = (float(MAX_FREQUENCY) - MIN_FREQUENCY) / DEFINITION
	set_size(size)


func _ready():
	var bus_id = AudioServer.get_bus_index(AUDIO_BUS_NAME)
	_spectrum = AudioServer.get_bus_effect_instance(bus_id, 0)


func _process(delta):
	for i in range(DEFINITION):
		var mag = _spectrum.get_magnitude_for_frequency_range(
				_frequency_interval * i,
				_frequency_interval * (i + 1))
		mag = linear2db(mag.length())
		mag = (mag - MIN_DB) / (MAX_DB - MIN_DB)
		mag = clamp(mag, 0, 1)
		mag = lerp(_histogram[i], mag, ACCELERATION * delta)
		_histogram[i] = mag
	
	update()


func _draw():
	for i in range(_histogram.size()):
		var begin = Vector2(BAR_WIDTH / 2.0 + _width_interval * i, 0)
		var end = begin + Vector2(0, -_histogram[i] * size.y)
		var transparency = min(1, _histogram[i] * BAR_TRANSPARENCY_MULTIPLIER)
		draw_line(begin, end, Color(1, 1, 1, transparency), BAR_WIDTH, false)


func set_size(new_size):
	size = new_size
	_width_interval = new_size.x / DEFINITION
