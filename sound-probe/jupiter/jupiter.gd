extends Position2D

export(PackedScene) var sprite
export(NodePath) var parallax_layer

func _ready():
	var sprite_instance = sprite.instance()
	var parallax_layer_instance = get_node(parallax_layer)
	sprite_instance.position = position * parallax_layer_instance.motion_scale
	parallax_layer_instance.add_child(sprite_instance, true)
