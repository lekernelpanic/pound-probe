extends Node2D
# Applies the rotation from the origin to destination


const MAX_DISTANCE = 40_000
const MIN_ALPHA = 0.04
const VANISH_DISTANCE = 12_000
const VANISHED_DISTANCE = 6_000

export(NodePath) var origin
export(NodePath) var destination
export var destination_parallax_scale = 1.0

var _origin_node
var _destination_node


func _ready():
	_origin_node = get_node(origin)
	_destination_node = get_node(destination)


func _process(_delta):
	var origin_position = _origin_node.global_position
	var destination_position =  _destination_node.position
	destination_position /= destination_parallax_scale
	var distance = origin_position.distance_to(destination_position)

	if distance > VANISH_DISTANCE:
		modulate.a = clamp(1 - distance / MAX_DISTANCE, MIN_ALPHA, 1)
	else:
		modulate.a = max((distance - VANISHED_DISTANCE) / VANISH_DISTANCE, 0)
	
	rotation = origin_position.angle_to_point(destination_position)
