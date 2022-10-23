extends CanvasLayer

export var appear = false

var ALPHA = 0.4

func _process(delta):
	
	if appear:
		visible = true
		$panel.modulate.a = clamp($panel.modulate.a + delta, 0, ALPHA)
	else:
		$panel.modulate.a = clamp($panel.modulate.a - delta, 0, ALPHA)
		if $panel.modulate.a <= 0:
			visible = false
	
	var viewport_rect = get_viewport().get_visible_rect().size
	$panel/visualizer.position.y = viewport_rect.y
	
	$panel/visualizer.size = viewport_rect
	$panel/visualizer.size.y /= 4
