extends Camera2D
# Manage screen shake


const INITIAL_ZOOM_FACTOR = 2
const ZOOM_SMOOTHNESS = 0.005
const SHAKE_OFFSET_FACTOR = 0.04
const SHAKE_DECAY = 5

var _final_zoom
var _shake_strength
var _rand


func _init():
	_final_zoom = zoom
	zoom = zoom * INITIAL_ZOOM_FACTOR
	
	_shake_strength = 0
	_rand = RandomNumberGenerator.new()
	_rand.randomize()


func _process(delta):
	zoom = zoom.lerp(_final_zoom, ZOOM_SMOOTHNESS)
	
	_shake_strength = lerpf(_shake_strength, 0, SHAKE_DECAY * delta)
	
	offset = Vector2(
			sin(Time.get_ticks_msec() * 0.03),
			sin(Time.get_ticks_msec() * 0.07)
	) * _shake_strength


func _on_probe_collision(force):
	_shake_strength = force * SHAKE_OFFSET_FACTOR
