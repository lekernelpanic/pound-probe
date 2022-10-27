extends RigidBody2D
# Probe movements and collision sound


const POWER = 60
const INITIAL_ZOOM = 0.5
const UNZOOM_SCALE = 128
const ZOOM_SMOOTHNESS = 0.005
const NORMAL_ZOOM = 2
const MIN_COLLISION_DB = 10

var _zoom


func _init():
	_zoom = INITIAL_ZOOM


func _process(delta):
	var power = delta * POWER
	
	$thrusters.rotation = -rotation
	
	if Input.is_action_pressed("left"):
		apply_impulse(Vector2 (), Vector2(-power, 0))
	if Input.is_action_pressed("right"):
		apply_impulse(Vector2 (), Vector2(power, 0))
	if Input.is_action_pressed("up"):
		apply_impulse(Vector2 (), Vector2(0, -power))
	if Input.is_action_pressed("down"):
		apply_impulse(Vector2 (), Vector2(0, power))

	_zoom = lerp(_zoom, NORMAL_ZOOM, ZOOM_SMOOTHNESS)
	$camera.zoom = Vector2(_zoom, _zoom)


func _on_probe_body_entered(body):
	if !$collision.playing:
		var collision_force = (linear_velocity - body.linear_velocity).length()
		$collision.volume_db = min(collision_force / 20, MIN_COLLISION_DB)
		$collision.volume_db -= MIN_COLLISION_DB
		$collision.play()
