extends Node2D
# General to the game.


func _ready() -> void:
	_scale_adaptation()
	get_tree().get_root().size_changed.connect(_scale_adaptation)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		if get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN


func _scale_adaptation() -> void:
	var size: float = get_window().size.y
	get_window().content_scale_factor = clamp(800.0 / size, 1, 1.5)
