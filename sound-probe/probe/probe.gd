extends RigidBody2D
# Probe movements and collision sound.


const INITIAL_ZOOM = 0.5
const ZOOM_SMOOTHNESS = 0.005
const MIN_COLLISION_DB = 10
const APPARITION_SPEED = 2
const MINIMAL_COLLISION_FORCE = 200

export(String, "voyager_1", "juno") var probe = "voyager_1" setget set_probe

var _zoom
var _probes


func _init():
	_zoom = INITIAL_ZOOM


func _ready():
	_probes = {	
		"voyager_1": $voyager_1,
		"juno": $juno,
	}
	set_probe(probe)


func _process(delta):
	_zoom = lerp(_zoom, 1, ZOOM_SMOOTHNESS)
	$camera.zoom = Vector2(_zoom, _zoom)
	
	for probe_name in _probes:
		var probe_material = _probes[probe_name].get_child(0).material
		var apparition_level = probe_material.get_shader_param("apparition")
		if(probe_name == probe):
			apparition_level = apparition_level + delta / APPARITION_SPEED
		else:
			apparition_level = apparition_level - delta / APPARITION_SPEED
		
		apparition_level = clamp(apparition_level, 0, 1)
		probe_material.set_shader_param("apparition", apparition_level)


func set_probe(new_probe):
	if(is_inside_tree()):
		var probe_node = _probes[probe]
		var new_probe_node = _probes[new_probe]
		probe_node.call_deferred("set_disabled", true)
		new_probe_node.call_deferred("set_disabled", false)
	probe = new_probe


func _on_probe_body_entered(body):
	var collision_force = (linear_velocity - body.linear_velocity).length()
	
	if !$collision.playing:
		$collision.volume_db = min(collision_force / 20, MIN_COLLISION_DB)
		$collision.volume_db -= MIN_COLLISION_DB
		$collision.play()
	
	if collision_force >= MINIMAL_COLLISION_FORCE:
		$recover_timer.wait_time = collision_force / 100
		$recover_timer.start()
		activate_probe(false)


func _on_recover_timer_timeout():
	activate_probe(true)


func activate_probe(activated):
	$thrusters.activated = activated
	$light.enabled = activated
	for probe_name in _probes:
		_probes[probe_name].get_child(0).material.set_shader_param(
				"on", activated)
