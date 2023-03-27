extends RigidBody2D
# Probe movements and collision sound.


signal collision(force)

enum probes {voyager_1, juno}

const APPARITION_SPEED: float = 2
const MINIMAL_COLLISION_FORCE: float = 200

@export var probe : probes : set = set_probe

var _probe_nodes: Dictionary


func _ready() -> void:
	_probe_nodes = {
		probes["voyager_1"]: $voyager_1,
		probes["juno"]: $juno,
	}
	set_probe(probe)


func _process(delta) -> void:
	
	if(Input.is_action_just_pressed("ui_accept")):
		print(position)
	
	for probe_name in _probe_nodes:
		var probe_node: Node2D = _probe_nodes[probe_name].get_child(0)
		var probe_mat: ShaderMaterial = probe_node.material
		var apparition: float = probe_mat.get_shader_parameter("apparition")
		if(probe_name == probe):
			apparition = apparition + delta / APPARITION_SPEED
		else:
			apparition = apparition - delta / APPARITION_SPEED
		
		apparition = clamp(apparition, 0, 1)
		probe_mat.set_shader_parameter("apparition", apparition)


func set_probe(new_probe) -> void:
	if is_inside_tree():
		_probe_nodes[probe].call_deferred("set_disabled", true)
		_probe_nodes[new_probe].call_deferred("set_disabled", false)
	probe = new_probe


func _on_probe_body_entered(body) -> void:
	emit_signal("collision", (linear_velocity - body.linear_velocity).length())


func _on_probe_collision(force) -> void:
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


func _on_recover_timer_timeout() -> void:
	_activate_probe(true)


func _activate_probe(activated) -> void:
	$thrusters.activated = activated
	$light.enabled = activated
	for probe_name in _probe_nodes:
		_probe_nodes[probe_name].get_child(0).material.set_shader_parameter(
				"on", activated)
