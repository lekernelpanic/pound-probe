extends Node2D

export(NodePath) var origin
export(NodePath) var destination
export var destination_parallax_scale = 1.0

var MAX_DISTANCE = 40000
var MIN_ALPHA = 0.04
var VANISH_DISTANCE = 12000
var VANISHED_DISTANCE = 6000

func _process(_delta):
	var origin_position = get_node(origin).global_position
	var destination_position =  get_node(destination).position / destination_parallax_scale
	var distance = origin_position.distance_to(destination_position)

	if distance > VANISH_DISTANCE:
		modulate.a = clamp(1 - distance / MAX_DISTANCE, MIN_ALPHA, 1)
	else:
		modulate.a = max((distance - VANISHED_DISTANCE) / VANISH_DISTANCE, 0)
	
	rotation = origin_position.angle_to_point(destination_position)
