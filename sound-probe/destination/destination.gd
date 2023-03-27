extends Area2D
# Puts the sprite in the parallax layer and detects probe's entrance.


@export var background: PackedScene
@export_node_path("ParallaxLayer") var layer: NodePath
@export var probe: String
@export var title: String
@export_multiline var text: String
@export var light_color: Color
@export var audio: AudioStream


func _ready() -> void:
	$description.title = title
	$description.text = text
	$point_light.color = light_color
	$audio_streamp_player.stream = audio
	$audio_streamp_player.playing = true
	
	var background_instance: Node2D = background.instantiate()
	var layer_instance: ParallaxLayer = get_node(layer)
	background_instance.position = position * layer_instance.motion_scale
	layer_instance.add_child(background_instance, true)


func _on_jupiter_body_entered(body) -> void:
	if(body.is_in_group("probe")):
		$description.appear = true
		body.probe = probe


func _on_jupiter_body_exited(body) -> void:
	if(body.is_in_group("probe")):
		$description.appear = false
