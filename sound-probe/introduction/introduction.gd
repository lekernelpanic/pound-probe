extends Area2D
# Manage the disparition.


var DISAPEARING_SPEED = 0.2

var _disapearing


func _process(delta):
	if _disapearing:
		$canvas_layer/panel.modulate.a -= delta * DISAPEARING_SPEED
		if $canvas_layer/panel.modulate.a <= 0:
			queue_free()


func _on_introduction_body_exited(body):
	if(body.is_in_group("probe")):
		_disapearing = true
