extends Sprite2D
# Apply rotation.


const ROTATION_SPEED = 0.05


func _process(delta) -> void:
	rotate(ROTATION_SPEED * delta)
