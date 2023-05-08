extends RigidBody2D
# Probe movements and collision sound.


signal collision(force: float)

const APPARITION_SPEED: float = 2
const MINIMAL_COLLISION_FORCE: float = 200

@export_enum("voyager_1",
		"van_allen_probe",
		"mars_2020_spacecraft",
		"parker_polar_probe",
		"soho",
		"juno",
		"cassini") var probe = "voyager_1" : set = set_probe

var _probe_nodes: Dictionary
var _transiting: bool


func _ready() -> void:
	_probe_nodes = {
		"voyager_1": $voyager_1,
		"soho": $soho,
		"van_allen_probe": $van_allen_probe,
		"mars_2020_spacecraft": $mars_2020_spacecraft,
		"parker_polar_probe": $parker_polar_probe,
		"juno": $juno,
		"cassini": $cassini,
	}
	set_probe(probe)


func _process(delta: float) -> void:
	if _transiting:
		_transiting = false
		for probe_name in _probe_nodes:
			_transiting = _manage_tranition(probe_name, delta) or _transiting


func set_probe(new_probe: String) -> void:
	if is_inside_tree():
		_probe_nodes[probe].call_deferred("set_disabled", true)
		_probe_nodes[new_probe].call_deferred("set_disabled", false)
	probe = new_probe
	_transiting = true


func _on_probe_body_entered(body: Node2D) -> void:
	emit_signal("collision", (linear_velocity - body.linear_velocity).length())


func _on_probe_collision(force: float) -> void:
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


func _activate_probe(activated: bool) -> void:
	$thrusters.activated = activated
	$light.enabled = activated
	for probe_name in _probe_nodes:
		_probe_nodes[probe_name].get_child(0).material.set_shader_parameter(
				"on", activated)


func _manage_tranition(probe_name: String, delta: float) -> bool:
	var probe_node = _probe_nodes[probe_name].get_child(0)
	var probe_mat: ShaderMaterial = probe_node.material
	var apparition: float = probe_mat.get_shader_parameter("apparition")
	
	if probe_name == probe:
		apparition = apparition + delta / APPARITION_SPEED
	else:
		apparition = apparition - delta / APPARITION_SPEED
	
	apparition = clamp(apparition, 0, 1)
	probe_mat.set_shader_parameter("apparition", apparition)
	
	return apparition > 0 and apparition < 1
