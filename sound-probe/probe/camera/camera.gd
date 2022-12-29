extends Camera2D
# Manage screen shake


const SHAKE_OFFSET_FACTOR = 0.04
const SHAKE_DECAY = 5

var _shake_strength
var _rand


func _init():
	_shake_strength = 0
	_rand = RandomNumberGenerator.new()
	_rand.randomize()


func _process(delta):
	_shake_strength = lerp(_shake_strength, 0, SHAKE_DECAY * delta)
	
	offset = Vector2(
			sin(OS.get_ticks_msec() * 0.03),
			sin(OS.get_ticks_msec() * 0.07)
	) * _shake_strength


func _on_probe_collision(force):
	_shake_strength = force * SHAKE_OFFSET_FACTOR
