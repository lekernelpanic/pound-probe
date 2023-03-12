extends RigidBody2D
# Probe movements and collision sound.


signal collision(force)

enum probes {voyager_1, juno}

const APPARITION_SPEED = 2
const MINIMAL_COLLISION_FORCE = 200

@export var probe : probes : set = set_probe

var _probe_nodes


func _ready():
	_probe_nodes = {
		probes["voyager_1"]: $voyager_1,
		probes["juno"]: $juno,
	}
	set_probe(probe)


func _process(delta):
	
	if(Input.is_action_just_pressed("ui_accept")):
		print(position)
	
	for probe_name in _probe_nodes:
		var probe_material = _probe_nodes[probe_name].get_child(0).material
		var apparition = probe_material.get_shader_parameter("apparition")
		if(probe_name == probe):
			apparition = apparition + delta / APPARITION_SPEED
		else:
			apparition = apparition - delta / APPARITION_SPEED
		
		apparition = clamp(apparition, 0, 1)
		probe_material.set_shader_parameter("apparition", apparition)


func set_probe(new_probe):
	if(is_inside_tree()):
		_probe_nodes[probe].call_deferred("set_disabled", true)
		_probe_nodes[new_probe].call_deferred("set_disabled", false)
	probe = new_probe


func _on_probe_body_entered(body):
	emit_signal("collision", (linear_velocity - body.linear_velocity).length())


func _on_probe_collision(force):
	if force >= MINIMAL_COLLISION_FORCE:
		$recover_timer.wait_time = force / 100
		$recover_timer.start()
		_activate_probe(false)
	
	Input.start_joy_vibration(
			0,
			clamp(force / 1000, 0, 1),
			clamp(force / 500, 0, 1),
			0.1
	)


func _on_recover_timer_timeout():
	_activate_probe(true)


func _activate_probe(activated):
	$thrusters.activated = activated
	$light.enabled = activated
	for probe_name in _probe_nodes:
		_probe_nodes[probe_name].get_child(0).material.set_shader_parameter(
				"on", activated)
