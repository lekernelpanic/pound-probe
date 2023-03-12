extends CanvasLayer
# Manage the apparition of the description and placement of the visualizer.


const ALPHA = 0.5

@export var appear: bool
@export var title: String : set = set_title
@export var text: String : set = set_text


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


func set_title(new_title):
	$panel/margin_container/v_box_container/title.text = new_title
	title = new_title


func set_text(new_text):
	$panel/margin_container/v_box_container/text.text = new_text
	text = new_text
