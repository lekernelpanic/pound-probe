extends RigidBody2D
# Set size during runtime and manage dust on collision


@export var applied_scale: float = 1.0 : set = set_applied_scale

var _dust_scene
var _collision_position


func _init():
	_dust_scene = preload("res://asteroids/dust/dust.tscn")


func _integrate_forces(state):
	if(state.get_contact_count() >= 1):
		_collision_position = state.get_contact_collider_position(0)


func set_applied_scale(new_applied_scale):
	applied_scale = new_applied_scale
	var scale_vector = Vector2(applied_scale, applied_scale)
	$sprite.scale = scale_vector
	$collision_polygon.scale = scale_vector
	$light_occluder.scale = scale_vector
	mass = 4.0 / 3.0 * PI * pow(applied_scale, 3)


func _on_asteroid_body_entered(_body):
	var dust = _dust_scene.instantiate()
	add_child(dust)
	dust.global_position = _collision_position
	dust.emitting = true
