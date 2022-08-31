extends Node2D

var OCURENCES = 400
var MAX_DISTANCE = 10000
var MAX_SCALE = 8
var MAX_LINEAR_VELOCITY = 100
var MAX_ANGULAR_VELOCITY = 0.2

var asteroid_scene = preload("res://asteroids/asteroid/asteroid.tscn")
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	for _n in range(OCURENCES):
		add_child(_generate_asteroid())

func _generate_asteroid():
	var asteroid = asteroid_scene.instance();
	asteroid.position = Vector2(random.randf_range(-MAX_DISTANCE, MAX_DISTANCE), random.randf_range(-MAX_DISTANCE, MAX_DISTANCE))
	asteroid.applied_scale = random.randf_range(1, MAX_SCALE)
	asteroid.linear_velocity = Vector2(random.randf_range(-100, 100), random.randf_range(-MAX_LINEAR_VELOCITY, MAX_LINEAR_VELOCITY))
	asteroid.angular_velocity = random.randf_range(0, MAX_ANGULAR_VELOCITY)
	return asteroid
