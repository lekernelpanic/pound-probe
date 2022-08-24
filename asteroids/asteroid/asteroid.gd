extends RigidBody2D

export var applied_scale = 1

func _ready():
	$collision_shape.scale = Vector2(applied_scale, applied_scale)
	$sprite.scale = Vector2(applied_scale, applied_scale)
