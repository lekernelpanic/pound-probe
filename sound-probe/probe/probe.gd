extends RigidBody2D

var POWER = 200
var MAX_SPEED = 500
var UNZOOM_SCALE = 128
var ZOOM_SMOOTHNESS = 0.005
var MIN_ZOOM = 1.5
var MAX_ZOOM = 3

var zoom = 0.5

func _process(delta):
	var power = delta * POWER
	
	$particles.rotation = -rotation
	$particles/left.emitting = false
	$particles/right.emitting = false
	$particles/up.emitting = false
	$particles/down.emitting = false
	
	if Input.is_action_pressed("left"):
		apply_impulse(Vector2 (), Vector2(-power, 0))
		$particles/right.emitting = true
	if Input.is_action_pressed("right"):
		apply_impulse(Vector2 (), Vector2(power, 0))
		$particles/left.emitting = true
	if Input.is_action_pressed("up"):
		apply_impulse(Vector2 (), Vector2(0, -power))
		$particles/down.emitting = true
	if Input.is_action_pressed("down"):
		apply_impulse(Vector2 (), Vector2(0, power))
		$particles/up.emitting = true
	
	var new_zoom = clamp(linear_velocity.length() / UNZOOM_SCALE, MIN_ZOOM, MAX_ZOOM)
	zoom = lerp(zoom, new_zoom, ZOOM_SMOOTHNESS)
	$camera.zoom = Vector2(zoom, zoom)
	
	if linear_velocity.length() > MAX_SPEED + 1:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
