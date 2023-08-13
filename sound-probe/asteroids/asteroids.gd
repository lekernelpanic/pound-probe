extends Node2D
# Generate the asteroids.


const OCURENCES: int = 1_000
const MAX_DISTANCE: float = 30_000
const DISTANCE_OFFSET: float = 1_000
const MIN_SCALE: float = 0.1
const MAX_SCALE: float = 1

@export var asteroid_scenes: Array[Resource]

var _rand: RandomNumberGenerator


func _init() -> void:
	_rand = RandomNumberGenerator.new()
	_rand.randomize()


func _ready() -> void:
	for _n in range(OCURENCES):
		add_child(_generate_asteroid())


func _generate_asteroid() -> RigidBody2D:
	var asteroid_index: int = _rand.randi_range(0, asteroid_scenes.size() - 1)
	var asteroid: RigidBody2D = asteroid_scenes[asteroid_index].instantiate()
	
	var distance: float = sqrt(
			_rand.randf_range(0, pow(MAX_DISTANCE, 2))) + DISTANCE_OFFSET
	var angle: float = _rand.randf_range(0, 2 * PI)
	asteroid.position = Vector2(distance * cos(angle), distance * sin(angle))

	asteroid.applied_scale = _rand.randf_range(MIN_SCALE, MAX_SCALE)
	
	return asteroid
