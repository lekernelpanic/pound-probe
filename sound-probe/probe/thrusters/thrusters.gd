extends Node2D
# Particles and sound of thrusters.


const POWER: float = 150
const ROTATION_POWER: float = 500
const MAX_ANGULAR_VELOCITY: float = 0.04
const CLOCKWISE: Dictionary = {
		"left": 0.5 * PI,
		"right": 1.5 * PI,
		"up": PI,
		"down": 0,
	}
const COUNTERCLOCKWISE: Dictionary = {
		"left": 1.5 * PI,
		"right": 0.5 * PI,
		"up": 0,
		"down": PI,
	}

@export var activated: bool = true

var _thrust_particles: Dictionary
var _rotate_particles: Dictionary


func _ready() -> void:
	_thrust_particles = {
		"left": $particles/left,
		"right": $particles/right,
		"up": $particles/up,
		"down": $particles/down,
	}
	_rotate_particles = {
		"left": $particles/rotation_left,
		"right": $particles/rotation_right,
		"up": $particles/rotation_up,
		"down": $particles/rotation_down,
	}


func _physics_process(delta) -> void:
	var thrust: Vector2 = Vector2()
	var thrust_rotation: float = 0
	
	for particles_name in _thrust_particles:
		_thrust_particles[particles_name].emitting = false
	for particles_name in _rotate_particles:
		_rotate_particles[particles_name].emitting = false
	
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
		owner.apply_impulse(thrust * delta, Vector2())
	
	if abs(thrust_rotation) > 0:
		_thrust_rotation_particules(thrust_rotation)
		owner.apply_torque_impulse(thrust_rotation * delta)
	
	if thrust.length() > 0 or abs(thrust_rotation) > 0:
		_audio(true)
	else:
		_audio(false)


func _thrust_particules(thrust) -> void:
	if thrust.x > 0:
		_thrust_particles["left"].emitting = true
	if thrust.x < 0:
		_thrust_particles["right"].emitting = true
	if thrust.y > 0:
		_thrust_particles["up"].emitting = true
	if thrust.y < 0:
		_thrust_particles["down"].emitting = true


func _thrust_rotation_particules(thrust_rotation) -> void:
	if thrust_rotation > 0:
		for particles in _rotate_particles:
			_rotate_particles[particles].rotation = CLOCKWISE[particles]
	elif thrust_rotation < 0:
		for particles in _rotate_particles:
			_rotate_particles[particles].rotation = COUNTERCLOCKWISE[particles]
	
	for particles_name in _rotate_particles:
		_rotate_particles[particles_name].emitting = true


func _audio(thrust) -> void:
	if thrust:
		if !$audio_stream_player.playing:
				$audio_stream_player.play()
	else:
		$audio_stream_player.stop()


func _automatic_stabilisation() -> float:
	var thrust_rotation: float = 0
	var angular_velocity: float = owner.angular_velocity
	
	if angular_velocity > MAX_ANGULAR_VELOCITY:
		thrust_rotation = -ROTATION_POWER
	elif angular_velocity < -MAX_ANGULAR_VELOCITY:
		thrust_rotation = ROTATION_POWER
	
	return thrust_rotation
