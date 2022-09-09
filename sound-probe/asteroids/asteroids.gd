extends Node2D

var OCURENCES = 512
var MAX_DISTANCE = 20000
var MIN_SCALE = 0.2
var MAX_SCALE = 2
var MAX_LINEAR_VELOCITY = 100
var MAX_ANGULAR_VELOCITY = 0.2

var asteroid_scenes = [
		preload("res://asteroids/asteroid_0/asteroid.tscn"),
		preload("res://asteroids/asteroid_1/asteroid.tscn"),
		preload("res://asteroids/asteroid_2/asteroid.tscn")
	]
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	for _n in range(OCURENCES):
		add_child(_generate_asteroid())

func _generate_asteroid():
	var asteroid_index = random.randi_range(0, asteroid_scenes.size() - 1)
	var asteroid = asteroid_scenes[asteroid_index].instance();
	
	var distance = sqrt(random.randf_range(0, pow(MAX_DISTANCE, 2)))
	var angle = random.randf_range(0, 2 * PI)
	asteroid.position = Vector2(distance * cos(angle), distance * sin(angle))
	
	asteroid.applied_scale = random.randf_range(MIN_SCALE, MAX_SCALE)
	asteroid.linear_velocity = Vector2(random.randf_range(-100, 100), random.randf_range(-MAX_LINEAR_VELOCITY, MAX_LINEAR_VELOCITY))
	asteroid.angular_velocity = random.randf_range(0, MAX_ANGULAR_VELOCITY)
	return asteroid
