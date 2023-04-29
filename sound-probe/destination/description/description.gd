extends CanvasLayer
# Manage the apparition of the description and placement of the visualizer.


@export var title: String : set = set_title
@export_multiline var text: String : set = set_text
@export_multiline var credits: String : set = set_credits

var _appear: bool

func _ready() -> void:
	_appear = true
	_size_adaptation()
	get_tree().get_root().size_changed.connect(_size_adaptation)


func _process(delta: float) -> void:
	if _appear:
		$panel.modulate.a = clamp($panel.modulate.a + delta, 0, 1)
	else:
		$panel.modulate.a = clamp($panel.modulate.a - delta, 0, 1)
		if $panel.modulate.a <= 0:
			queue_free()


func _size_adaptation() -> void:
	var viewport_rect: Vector2 = get_viewport().get_visible_rect().size
	var visualizer = $panel/visualizer
	visualizer.size.x = viewport_rect.x * 0.15
	visualizer.size.y = viewport_rect.y * 0.5
	visualizer.position.x = viewport_rect.x - visualizer.size.y * 0.5
	visualizer.position.y = viewport_rect.y * 0.75


func quit():
	_appear = false


func set_title(new_title: String) -> void:
	$panel/margin_container/v_box_container/title.text = new_title
	title = new_title


func set_text(new_text: String) -> void:
	$panel/margin_container/v_box_container/text.text = new_text
	text = new_text


func set_credits(new_credits: String) -> void:
	$panel/margin_container/v_box_container/sound_credits.text = new_credits
	credits = new_credits
