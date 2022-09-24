extends Node2D

export(NodePath) var origin
export(NodePath) var destination

var MAX_DISTANCE = 20000
var MIN_ALPHA = 0.04

func _process(_delta):
	var origin_position = get_node(origin).global_position
	var destination_position =  get_node(destination).global_position

	modulate.a = clamp(1 - (origin_position.distance_to(destination_position)) / MAX_DISTANCE, MIN_ALPHA, 1)
	rotation = origin_position.angle_to_point(destination_position)
