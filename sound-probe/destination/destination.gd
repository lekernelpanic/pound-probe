extends Area2D
# Puts the sprite in the parallax layer and detects probe's entrance.


@export var sprite: PackedScene
@export var parallax_layer: NodePath
@export var probe: String
@export var title: String
@export var text: String
@export var light_color: Color
@export var audio: AudioStream


func _ready():
	$description.title = title
	$description.text = text
	$point_light.color = light_color
	$audio_streamp_player.stream = audio
	$audio_streamp_player.playing = true
	
	var sprite_instance = sprite.instantiate()
	var parallax_layer_instance = get_node(parallax_layer)
	sprite_instance.position = position * parallax_layer_instance.motion_scale
	parallax_layer_instance.add_child(sprite_instance, true)


func _on_jupiter_body_entered(body):
	if(body.is_in_group("probe")):
		$description.appear = true
		body.probe = probe


func _on_jupiter_body_exited(body):
	if(body.is_in_group("probe")):
		$description.appear = false
