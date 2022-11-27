extends Area2D
# Puts the sprite in the parallax layer and detects probe's entrance.


export(PackedScene) var sprite
export(NodePath) var parallax_layer
export(String) var probe
export(String) var title
export(String) var text
export(AudioStream) var audio


func _ready():
	$description.title = title
	$description.text = text
	$audio_streamp_player.stream = audio
	$audio_streamp_player.playing = true
	
	var sprite_instance = sprite.instance()
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
