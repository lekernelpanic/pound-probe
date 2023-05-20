extends Node2D
# Generate the asteroids.


const OCURENCES: int = 1_000
const MAX_DISTANCE: float = 30_000
const DISTANCE_OFFSET: float = 1_000
const MIN_SCALE: float = 0.1
const MAX_SCALE: float = 1
const MAX_LINEAR_VELOCITY: float = 50
const MAX_ANGULAR_VELOCITY: float = 0.2

var _asteroid_scenes: Array[Resource]
var _rand: RandomNumberGenerator


func _init() -> void:
	_rand = RandomNumberGenerator.new()
	_rand.randomize()
	
	_asteroid_scenes = [
		preload("res://asteroids/asteroid_0/asteroid.tscn"),
		preload("res://asteroids/asteroid_1/asteroid.tscn"),
		preload("res://asteroids/asteroid_2/asteroid.tscn"),
		preload("res://asteroids/asteroid_3/asteroid.tscn"),
	]


func _ready() -> void:
	for _n in range(OCURENCES):
		add_child(_generate_asteroid())


func _generate_asteroid() -> RigidBody2D:
	var asteroid_index: int = _rand.randi_range(0, _asteroid_scenes.size() - 1)
	var asteroid: RigidBody2D = _asteroid_scenes[asteroid_index].instantiate()
	
	var distance: float = sqrt(
			_rand.randf_range(0, pow(MAX_DISTANCE, 2))) + DISTANCE_OFFSET
	var angle: float = _rand.randf_range(0, 2 * PI)
	asteroid.position = Vector2(distance * cos(angle), distance * sin(angle))

	asteroid.applied_scale = _rand.randf_range(MIN_SCALE, MAX_SCALE)
	asteroid.linear_velocity = Vector2(
			_rand.randf_range(-MAX_LINEAR_VELOCITY, MAX_LINEAR_VELOCITY),
			_rand.randf_range(-MAX_LINEAR_VELOCITY, MAX_LINEAR_VELOCITY))
	asteroid.angular_velocity = _rand.randf_range(0, MAX_ANGULAR_VELOCITY)
	
	return asteroid
