extends Node2D
# Analyze an audio bus and draw the visualizer.


const AUDIO_BUS_NAME: String = "space_sound"
const DEFINITION: int = 200
const MIN_FREQUENCY: float = 20
const MAX_FREQUENCY: float = 20_000
const MAX_DB: float = 0
const MIN_DB: float = -180
const ACCELERATION: float = 4
const BAR_WIDTH: float = 8
const BAR_TRANSPARENCY_MULTIPLIER: float = 4

@export var size: Vector2 : set = set_size

var _spectrum: AudioEffectInstance
var _frequency_interval: float
var _width_interval: float
var _histogram: Array[float]


func _init() -> void:
	_histogram = []
	for _i in range(DEFINITION):
		_histogram.append(0)
	
	_frequency_interval = (float(MAX_FREQUENCY) - MIN_FREQUENCY) / DEFINITION
	set_size(size)


func _ready() -> void:
	var bus_id: int = AudioServer.get_bus_index(AUDIO_BUS_NAME)
	_spectrum = AudioServer.get_bus_effect_instance(bus_id, 0)


func _process(delta: float) -> void:
	for i in range(DEFINITION):
		var mag: float = _spectrum.get_magnitude_for_frequency_range(
				_frequency_interval * i,
				_frequency_interval * (i + 1)).length()
		mag = linear_to_db(mag)
		mag = (mag - MIN_DB) / (MAX_DB - MIN_DB)
		mag = clampf(mag, 0, 1)
		mag = lerpf(_histogram[i], mag, ACCELERATION * delta)
		_histogram[i] = mag
	
	queue_redraw()


func _draw() -> void:
	for i in range(_histogram.size()):
		var begin: Vector2 = Vector2(BAR_WIDTH / 2.0 + _width_interval * i, 0)
		var end: Vector2 = begin + Vector2(0, -_histogram[i] * size.y)
		var transparency: float = _histogram[i] * BAR_TRANSPARENCY_MULTIPLIER
		transparency = min(1, transparency)
		draw_line(begin,end,Color(1, 1, 1, transparency),BAR_WIDTH)


func set_size(new_size: Vector2) -> void:
	size = new_size
	_width_interval = new_size.x / DEFINITION
