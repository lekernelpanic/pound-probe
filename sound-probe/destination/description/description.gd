extends CanvasLayer
# Manage the apparition of the description and placement of the visualizer.


@export var appear: bool
@export var title: String : set = set_title
@export_multiline var text: String : set = set_text


func _process(delta: float) -> void:
	if appear:
		visible = true
		$panel.modulate.a = clamp($panel.modulate.a + delta, 0, 1)
	else:
		$panel.modulate.a = clamp($panel.modulate.a - delta, 0, 1)
		if $panel.modulate.a <= 0:
			visible = false
	
	var viewport_rect: Vector2 = get_viewport().get_visible_rect().size
	$panel/visualizer.position.y = viewport_rect.y
	
	$panel/visualizer.size = viewport_rect
	$panel/visualizer.size.y /= 4


func set_title(new_title: String) -> void:
	$panel/margin_container/v_box_container/title.text = new_title
	title = new_title


func set_text(new_text: String) -> void:
	$panel/margin_container/v_box_container/text.text = new_text
	text = new_text
