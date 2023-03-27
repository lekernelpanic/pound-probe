extends ParallaxLayer
# Offset correction for the layer.


func _ready() -> void:
	_offset_correction()
	get_tree().get_root().size_changed.connect(_offset_correction)


func _offset_correction() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	motion_offset = viewport_size / 2.0 * (Vector2(1, 1) - motion_scale)
