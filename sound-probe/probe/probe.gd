extends RigidBody2D

var POWER = 60
var UNZOOM_SCALE = 128
var ZOOM_SMOOTHNESS = 0.005
var NORMAL_ZOOM = 2
var MIN_COLLISION_DB = 10

var zoom = 0.5

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

	zoom = lerp(zoom, NORMAL_ZOOM, ZOOM_SMOOTHNESS)
	$camera.zoom = Vector2(zoom, zoom)

func _on_probe_body_entered(body):
	if !$collision.playing:
		var collision_force = (linear_velocity - body.linear_velocity).length()
		$collision.volume_db = min(collision_force / 20, MIN_COLLISION_DB) - MIN_COLLISION_DB
		$collision.play()
