extends Node2D
# Generate the asteroids
# Position, size and velocity applied randomly

var OCURENCES = 512
var MAX_DISTANCE = 20_000
var DISTANCE_OFFSET = 1_000
var MIN_SCALE = 0.2
var MAX_SCALE = 2
var MAX_LINEAR_VELOCITY = 100
var MAX_ANGULAR_VELOCITY = 0.2

var _asteroid_scenes
var _random

func _init():
	_random = RandomNumberGenerator.new()
	_random.randomize()
	
	_asteroid_scenes = [
		preload("res://asteroids/asteroid_0/asteroid.tscn"),
		preload("res://asteroids/asteroid_1/asteroid.tscn"),
		preload("res://asteroids/asteroid_2/asteroid.tscn"),
		preload("res://asteroids/asteroid_3/asteroid.tscn"),
	]


func _ready():
	for _n in range(OCURENCES):
		add_child(_generate_asteroid())


func _generate_asteroid():
	var asteroid_index = _random.randi_range(0, _asteroid_scenes.size() - 1)
	var asteroid = _asteroid_scenes[asteroid_index].instance();
	
	var distance = sqrt(
			_random.randf_range(0, pow(MAX_DISTANCE, 2))) + DISTANCE_OFFSET
	var angle = _random.randf_range(0, 2 * PI)
	asteroid.position = Vector2(distance * cos(angle), distance * sin(angle))
	
	asteroid.applied_scale = _random.randf_range(MIN_SCALE, MAX_SCALE)
	asteroid.linear_velocity = Vector2(
			_random.randf_range(-100, 100),
			_random.randf_range(-MAX_LINEAR_VELOCITY, MAX_LINEAR_VELOCITY))
	asteroid.angular_velocity = _random.randf_range(0, MAX_ANGULAR_VELOCITY)
	
	return asteroid
