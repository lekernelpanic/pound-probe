extends Node2D
# General to the game.


func _ready():
	_scale_adaptation()
	get_tree().get_root().size_changed.connect(_scale_adaptation)


func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		if get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	
	
	if event.is_action_pressed("exit"):
		$exit_timer.start()
		$ui/exit.visible = true

	if event.is_action_released("exit"):
		$exit_timer.stop()
		$ui/exit.visible = false


func _on_exit_timer_timeout():
	get_tree().quit()


func _scale_adaptation():
	var size = get_window().size.y
	get_window().content_scale_factor = clamp(800.0 / size, 1, 1.5)
