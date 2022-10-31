extends RigidBody2D
# Alltrows to set size during runtime.


export(float) var applied_scale = 1.0 setget set_applied_scale


func set_applied_scale(new_applied_scale):
	applied_scale = new_applied_scale
	var scale_vector = Vector2(applied_scale, applied_scale)
	$sprite.scale = scale_vector
	$collision_polygon.scale = scale_vector
	$light_occluder.scale = scale_vector
	mass = applied_scale
