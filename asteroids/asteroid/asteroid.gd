extends RigidBody2D

export var applied_scale = 1

func _ready():
	var scale_vector = Vector2(applied_scale, applied_scale)
	$sprite.scale = scale_vector
	$collision_polygon.scale = scale_vector
	$light_occluder.scale = scale_vector
