extends Area2D

export(PackedScene) var sprite
export(NodePath) var parallax_layer

func _ready():
	var sprite_instance = sprite.instance()
	var parallax_layer_instance = get_node(parallax_layer)
	sprite_instance.position = position * parallax_layer_instance.motion_scale
	parallax_layer_instance.add_child(sprite_instance, true)

func _on_jupiter_body_entered(body):
	if(body.is_in_group("probe")):
		$description.appear = true

func _on_jupiter_body_exited(body):
	if(body.is_in_group("probe")):
		$description.appear = false
