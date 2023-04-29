extends Area2D
# Puts the sprite in the parallax layer and detects probe's entrance.


@export var background: PackedScene
@export_node_path("ParallaxLayer") var layer: NodePath
@export var probe: String
@export var title: String
@export_multiline var text: String
@export var credits: String
@export var light_color: Color
@export var audio: AudioStream

var _description: Resource
var _description_instance: CanvasLayer


func _init() -> void:
	_description = preload("res://destination/description/description.tscn")


func _ready() -> void:
	$point_light.color = light_color
	$audio_stream_player.stream = audio
	$audio_stream_player.playing = true
	
	var background_instance: Node2D = background.instantiate()
	var layer_instance: ParallaxLayer = get_node(layer)
	background_instance.position = position * layer_instance.motion_scale
	layer_instance.add_child(background_instance, true)


func _on_body_entered(body):
	if body.is_in_group("probe"):
		_description_instance = _description.instantiate()
		_description_instance.title = title
		_description_instance.text = text
		_description_instance.credits = credits
		add_child(_description_instance)
		body.probe = probe


func _on_body_exited(body):
	if body.is_in_group("probe"):
		_description_instance.quit()
