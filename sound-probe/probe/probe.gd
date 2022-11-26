extends RigidBody2D
# Probe movements and collision sound.


const POWER = 60
const INITIAL_ZOOM = 0.5
const UNZOOM_SCALE = 128
const ZOOM_SMOOTHNESS = 0.005
const NORMAL_ZOOM = 2
const MIN_COLLISION_DB = 10
const APPARITION_SPEED = 2

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
	var power = delta * POWER
	
	$thrusters.rotation = -rotation
	
	if Input.is_action_pressed("left"):
		apply_impulse(Vector2 (), Vector2(-power, 0))
	if Input.is_action_pressed("right"):
		apply_impulse(Vector2 (), Vector2(power, 0))
	if Input.is_action_pressed("up"):
		apply_impulse(Vector2 (), Vector2(0, -power))
	if Input.is_action_pressed("down"):
		apply_impulse(Vector2 (), Vector2(0, power))
	
	_zoom = lerp(_zoom, NORMAL_ZOOM, ZOOM_SMOOTHNESS)
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
	if !$collision.playing:
		var collision_force = (linear_velocity - body.linear_velocity).length()
		$collision.volume_db = min(collision_force / 20, MIN_COLLISION_DB)
		$collision.volume_db -= MIN_COLLISION_DB
		$collision.play()
