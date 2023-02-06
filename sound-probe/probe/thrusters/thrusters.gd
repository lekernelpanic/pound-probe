extends Node2D
# Particles and sound of thrusters.


const POWER = 150
const ROTATION_POWER = 500
const MAX_ANGULAR_VELOCITY = 0.04
const CLOCKWISE = {
		"left": 0.5 * PI,
		"right": 1.5 * PI,
		"up": PI,
		"down": 0,
	}
const COUNTERCLOCKWISE = {
		"left": 1.5 * PI,
		"right": 0.5 * PI,
		"up": 0,
		"down": PI,
	}

export(bool) var activated = true

var _particles
var _rotation_particles


func _ready():
	_particles = {
		"left": $particles/left,
		"right": $particles/right,
		"up": $particles/up,
		"down": $particles/down,
	}
	_rotation_particles = {
		"left": $particles/rotation_left,
		"right": $particles/rotation_right,
		"up": $particles/rotation_up,
		"down": $particles/rotation_down,
	}


func _physics_process(delta):
	var thrust = Vector2()
	var thrust_rotation = 0
	
	for particles_name in _particles:
		_particles[particles_name].emitting = false
	for particles_name in _rotation_particles:
		_rotation_particles[particles_name].emitting = false
	
	if activated:
		if Input.is_action_pressed("left"):
			thrust.x = -1
		if Input.is_action_pressed("right"):
			thrust.x = 1
		if Input.is_action_pressed("up"):
			thrust.y = -1
		if Input.is_action_pressed("down"):
			thrust.y = 1
		
		thrust = thrust.rotated(-get_global_rotation())
		thrust = thrust.round() * POWER
		
		thrust_rotation = _automatic_stabilisation()

	if thrust.length() > 0:
		_thrust_particules(thrust)
		thrust = thrust.rotated(get_global_rotation())
		owner.apply_impulse(Vector2(), thrust * delta)
	
	if abs(thrust_rotation) > 0:
		_thrust_rotation_particules(thrust_rotation)
		owner.apply_torque_impulse(thrust_rotation * delta)
	
	if thrust.length() > 0 or abs(thrust_rotation) > 0:
		_audio(true)
	else:
		_audio(false)


func _thrust_particules(thrust):
	if thrust.x > 0:
		_particles["left"].emitting = true
	if thrust.x < 0:
		_particles["right"].emitting = true
	if thrust.y > 0:
		_particles["up"].emitting = true
	if thrust.y < 0:
		_particles["down"].emitting = true


func _thrust_rotation_particules(thrust_rotation):
	if thrust_rotation > 0:
		for name in _rotation_particles:
			_rotation_particles[name].rotation = CLOCKWISE[name]
	elif thrust_rotation < 0:
		for name in _rotation_particles:
			_rotation_particles[name].rotation = COUNTERCLOCKWISE[name]
	
	for particles_name in _rotation_particles:
		_rotation_particles[particles_name].emitting = true


func _audio(thrust):
	if thrust:
		if !$audio_stream_player.playing:
				$audio_stream_player.play()
	else:
		$audio_stream_player.stop()


func _automatic_stabilisation():
	var thrust_rotation = 0
	var angular_velocity = owner.angular_velocity
	
	if angular_velocity > MAX_ANGULAR_VELOCITY:
		thrust_rotation = -ROTATION_POWER
	elif angular_velocity < -MAX_ANGULAR_VELOCITY:
		thrust_rotation = ROTATION_POWER
	
	return thrust_rotation
