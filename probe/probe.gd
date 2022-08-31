extends RigidBody2D

var POWER = 40
var IMPULSE_CONSUMPTION = 50
var REFILL_SPEED = 40
var UNZOOM_SCALE = 128
var ZOOM_SMOOTHNESS = 0.005
var MIN_ZOOM = 1
var MAX_ZOOM = 3

var zoom = 1

func _input(event):
	if probe.rcs >= IMPULSE_CONSUMPTION:
		if event.is_action_pressed("left"):
			apply_impulse(Vector2 (), Vector2(-POWER, 0))
			probe.rcs -= IMPULSE_CONSUMPTION
		if event.is_action_pressed("right"):
			apply_impulse(Vector2 (), Vector2(POWER, 0))
			probe.rcs -= IMPULSE_CONSUMPTION
		if event.is_action_pressed("up"):
			apply_impulse(Vector2 (), Vector2(0, -POWER))
			probe.rcs -= IMPULSE_CONSUMPTION
		if event.is_action_pressed("down"):
			apply_impulse(Vector2 (), Vector2(0, POWER))
			probe.rcs -= IMPULSE_CONSUMPTION

func _process(delta):
	var new_zoom = clamp(linear_velocity.length() / UNZOOM_SCALE, MIN_ZOOM, MAX_ZOOM)
	zoom = lerp(zoom, new_zoom, ZOOM_SMOOTHNESS)
	$camera.zoom = Vector2(zoom, zoom)
	
	if probe.rcs < 100:
		probe.rcs += delta * REFILL_SPEED
	else:
		probe.rcs = 100
