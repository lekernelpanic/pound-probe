extends Node2D
# Analyze an audio bus and draw the visualizer.


const AUDIO_BUS_NAME: String = "space_sound"
const DEFINITION: int = 32
const MIN_FREQUENCY: float = 20
const MAX_FREQUENCY: float = 20_000
const MAX_DB: float = 0
const MIN_DB: float = -120
const ACCELERATION: float = 4
const BAR_WIDTH: float = 16

@export var size: Vector2 : set = set_size
@export var styleBox: StyleBox

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
	for i: int in range(DEFINITION):
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
	for i: int in range(_histogram.size()):
		var bar_size: float = _histogram[i] * size.x
		var relative_position: Vector2 = Vector2(
				-bar_size / 2.0,
				-(BAR_WIDTH + _width_interval * i))
		var rect_size: Vector2 = Vector2(bar_size, BAR_WIDTH)
		
		var color: Color = styleBox.get_bg_color()
		color.a = min(1, _histogram[i])
		styleBox.set_bg_color(color)
		
		draw_style_box(styleBox, Rect2(relative_position, rect_size))


func set_size(new_size: Vector2) -> void:
	size = new_size
	_width_interval = new_size.y / DEFINITION
